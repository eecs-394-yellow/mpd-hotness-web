<?php
header('content-type: text/plain');

require('./database-util.php');

$con = get_connection();

$sql = 'SELECT uuid_from_binary(device_id), user_name, time, location_description, note_text FROM Note';

if($sth = $con->query($sql)) {
    print_r($sth->fetchAll(PDO::FETCH_ASSOC));
}
else {
    $ei = $con->errorInfo();
    die($ei[2]);
}
