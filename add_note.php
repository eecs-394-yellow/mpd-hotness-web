<?php
require('config.php');
require('database-util.php');

class ArgumentMissingException extends Exception {
    function __construct($missing_args) {
        $this->args = $missing_args;
        Exception::__construct('Missing arguments ' . implode(', ', $this->args));
    }
}

function point_wkt($lat, $lon) {
    if(is_numeric($lat) and is_numeric($lon)) {
        return "POINT($lat $lon)";
    }
    else {
        throw new Exception("Either latitude or longitude is not numeric");
    }
}

function get_add_note_args($req) {
    $args = array();
    $missing = array();
    $required = array('device_id', 'user_name', 'location_text', 'note');
    foreach($required as $required_arg) {
        if(empty($req[$required_arg])) {
            $missing[] = $required_arg;
        }
        else {
            $args[$required_arg] = $req[$required_arg];
        }
    }
    $args['gps_wkt'] = point_wkt($req['lat'], $req['lon']);
    if(count($missing)) {
        throw new ArgumentMissingException($missing);
    }
    return $args;
}

function add_note($con, $args) {
    return $con->call_procedure('add_note', $args);
}

$con = get_connection();

try {
    $args = get_add_note_args($_REQUEST);
    add_note($con, $args);
    $output = array('succeeded' => 1);
}
catch(Exception $e) {
    $output = array('succeeded' => 0, 'error' => $e->getMessage());
}

echo json_encode($output);
?>
