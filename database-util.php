<?php

if(get_magic_quotes_gpc()) {
    foreach($_REQUEST as $k => $v) {
        $_REQUEST[$k] = stripslashes($v);
    }
}

require('json-pretty.php');

function jsonp_print($struct) {
    echo $_REQUEST['callback'] . '(' . json_indent(json_encode($struct)) . ')';
}

function last_error_str($sth) {
    $ei = $sth->errorInfo();
    return $ei[2];
}

function point_wkt($lat, $lon) {
    if(is_numeric($lat) and is_numeric($lon)) {
        return "POINT($lat $lon)";
    }
    else {
        throw new Exception("Either latitude or longitude is not numeric");
    }
}

class ProcedureCallError extends Exception { }

// Utility class to keep queries out of client code
class MPDHotnessPDO extends PDO {
    private $queries;
    private $prepare_cache = array();

    // Save the queries and let the superclass connect
    public function __construct($dsn, $user, $pass, $inifile) {
        parent::__construct($dsn, $user, $pass);
        $this->queries = parse_ini_file($inifile, true, INI_SCANNER_RAW);
    }

    // Prepare a statement for execution and cache the statement handler
    private function prepare_cached($proc_name) {
        if(array_key_exists($proc_name, $this->prepare_cache)) {
            return $this->prepare_cache[$proc_name];
        }
        else if(array_key_exists($proc_name, $this->queries)) {
            $sql = $this->queries[$proc_name]['sql'];
            return ($this->prepare_cache[$proc_name] = $this->prepare($sql));
        }
        else {
            throw new ProcedureCallError("Query '$proc_name' not defined.");
        }
    }

    // Call a procedure (or any cached statement) with $args (or null).
    // Pass $result_type = PDO::FETCH_ASSOC for queries with results
    // throws ProcedureCallError on failure
    public function call_procedure($proc_name, $args = null, $result_type = null) {
        $sth = $this->prepare_cached($proc_name);
        if($args !== null) {
            $result = $sth->execute($args);
        }
        else {
            $result = $sth->execute();
        }

        if(!$result) {
            throw new ProcedureCallError(last_error_str($sth));
        }

        if($result_type !== null) {
            return $sth->fetchAll($result_type);
        }
        return $result;
    }
}

// Get a database handle using the application's configuration
function get_connection() {
    require('database-config.php');
    try {
        return new MPDHotnessPDO($DSN, $USER, $PASS, 'database-queries.ini');
    }
    catch(PDOException $e) {
        die(json_encode(array('succeeded' => 0, 'error' => $e->getMessage())));
    }
}
?>
