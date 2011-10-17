<?php

require('./database-config.php');

$con = new PDO("mysql:host=$HOST;dbname=$DB", $USER, $PASS);

if(!$con) {
    die('Could not connect: ' . mysql_error());
}
	
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
