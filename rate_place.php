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

function get_rate_place_args($req) {
    $args = array();
    $missing = array();
    $required = array('place_id', 'rating');
    foreach($required as $required_arg) {
        if(empty($req[$required_arg])) {
            $missing[] = $required_arg;
        }
        else {
            $args[$required_arg] = $req[$required_arg];
        }
    }
    $args['location'] = point_wkt(@$req['lat'], @$req['lon']);
    if(count($missing)) {
        throw new ArgumentMissingException($missing);
    }
    return $args;
}

$con = get_connection();

try {
    $args = get_rate_place_args($_REQUEST);
    $con->call_procedure('rate_place', $args);
    $output = array('succeeded' => 1);
}
catch(Exception $e) {
    $output = array('succeeded' => 0, 'error' => $e->getMessage());
}

jsonp_print($output);
?>
