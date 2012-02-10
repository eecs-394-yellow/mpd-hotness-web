<?php

header('content-type: text/plain');

require('config.php');
require('database-util.php');

if(empty($_GET['place_id'])) {
    $message = array('error: place_id not specified');
}
else {
    $args = array('place_id' => $_GET['place_id'], 'max_age_minutes' => 60);
    $dbh = get_connection();
    list($message) = $dbh->call_procedure('get_place_details', $args, PDO::FETCH_ASSOC);
}

jsonp_print($message);

?>
