<?php

require('./database-util.php');

$con = get_connection();
	
$sql = 'CALL usp_insert_note(?, ?, ?, ?);';
$sth = $con->prepare($sql);

if(!$sth->execute(array($_POST['deviceIdField'],
                    $_POST['authorField'], 
                    $_POST['locationField'],
                    $_POST['notesField'])) {
    die('Error: ' . $sth->errorCode());
}
echo "Note added!";

?>
