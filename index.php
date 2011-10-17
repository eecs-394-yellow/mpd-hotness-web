<?php
// submission page.  Should this be the index?
require('config.php');
require('database-util.php');

$con = get_connection();
$sql = 'CALL usp_insert_note(?, ?, ?, ?);';
$sth = $con->prepare($sql);

if(!$sth->execute(array($_POST['deviceIdField'],
                        $_POST['authorField'],
                        $_POST['locationField'],
                        $_POST['notesField']))) {
    $ei = $sth->errorInfo();
    die('Error: ' . $ei[2]);
}
echo "Note added!";

?>
