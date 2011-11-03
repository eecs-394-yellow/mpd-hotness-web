<?php
header('content-type: text/plain');

require('config.php');
require('database-util.php');

try {
    $con = get_connection();
    $message = $con->call_procedure('get_all_places', null, PDO::FETCH_ASSOC);
}
catch(ProcedureCallError $err) {
    $message = array('error' => $err->getMessage());
}
catch(Exception $ex) {
    $message = array('error' => last_error_str($ex));
}

jsonp_print($message);
