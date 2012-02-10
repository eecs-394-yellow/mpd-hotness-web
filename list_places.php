<?php

header('content-type: text/plain');

require('config.php');
require('database-util.php');

function get_args() {
    $age = !empty($_GET['max_age_minutes']) ? $_GET['max_age_minutes'] : 30;
    $gps = point_wkt(@$_GET['lat'], @$_GET['lon']);
    return array('max_age_minutes' => $age, 'gps' => $gps, 'max_distance' => 10);
}

try {
    $con = get_connection();
    $gps = point_wkt($_GET['lat'], $_GET['lon']);
    $data = $con->call_procedure('get_closest_places', get_args(), PDO::FETCH_ASSOC);
    if(@$_GET['version'] == '2') {
        $message = array();
        foreach($data as $row) {
            $id = $row['place_id'];
            unset($row['place_id']);
            $message[$id] = $row;
        }
    }
    else {
        $message = $data;
    }
}
catch(ProcedureCallError $err) {
    $message = array('error' => $err->getMessage());
}
catch(Exception $ex) {
    $message = array('error' => last_error_str($ex));
}

jsonp_print($message);

?>
