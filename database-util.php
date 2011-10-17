<?php

function get_connection() {
    require('./database-config.php');
    try {
        return new PDO($dsn, $USER, $PASS);
    }
    catch(PDOException $e) {
        die('Could not connect: ' . $e->getMessage());
    }
}
?>
