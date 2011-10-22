<?php
require('config.php');
require('database-util.php');

class ArgumentMissingException extends Exception {
    function __construct($missing_args) {
        $this->args = $missing_args;
        Exception::__construct('Missing arguments ' . implode(', ', $this->args));
    }
}

function add_note($con, $args) {
    return $con->call_procedure('add_note', $args);
}

function get_add_note_args($req) {
    $args = array();
    $missing = array();
    $required = array('device_id', 'author', 'location', 'note');
    foreach($required as $required_arg) {
        if(empty($req[$required_arg])) {
            $missing[] = $required_arg;
        }
        else {
            $args[] = $req[$required_arg];
        }
    }
    if(count($missing)) {
        throw new ArgumentMissingException($missing);
    }
    return $args;
}

$con = get_connection();

try {
    $args = get_add_note_args($_REQUEST);
    add_note($con, $args);
    $output = array('succeeded' => 1);
}
catch(ArgumentMissingException $e) {
    $output = array('succeeded' => 0, 'error' => $e->getMessage());
}

echo json_encode($output);
?>
