<?php

header('content-type: text/plain');

require('config.php');
require('database-util.php');

function get_args() {
    $age = !empty($_GET['max_age_minutes']) ? $_GET['max_age_minutes'] : 30;
    $gps = point_wkt(@$_GET['lat'], @$_GET['lon']);
    return array('max_age_minutes' => $age, 'gps' => $gps);
}

try {
    $con = get_connection();
    $gps = point_wkt($_GET['lat'], $_GET['lon']);
    $message = $con->call_procedure('get_closest_places', get_args(), PDO::FETCH_ASSOC);
}
catch(ProcedureCallError $err) {
    $message = array('error' => $err->getMessage());
}
catch(Exception $ex) {
    $message = array('error' => last_error_str($ex));
}

jsonp_print($message);

?>
