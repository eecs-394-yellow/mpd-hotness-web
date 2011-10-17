<?php
$con = mysql_connect("SERVER_ADDRESS","SQL_USERNAME","SQL_PASS");
if(!$con)
	{
	die('Could not connect: ' . mysql_error());
	}
	
mysql_select_db("Note", $con);

$sql="INSERT INTO Note (user_name, location_description, note_text)
VALUES
('$_POST[authorField]','$_POST[locationField]','$_POST[notesField]')";

if (!mysql_query($sql,$con))
	{
	die('Error: ' . mysql_error());
	}
echo "Note added!";

mysql_close($con);
?>