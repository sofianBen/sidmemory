<?php
require("db/connect.php");

$procedure = oci_parse($dbConn, 'call insert_coup(:p_idpartie, :p_idjoueur, :p_carte1, :p_carte2,:retour)');

oci_bind_by_name($procedure, ':p_idpartie', $_GET['idpartie'],5);
oci_bind_by_name($procedure, ':p_idjoueur', $_GET['idjoueur'],50);
oci_bind_by_name($procedure, ':p_carte1', $_GET['carte1'], 50);
oci_bind_by_name($procedure, ':p_carte2', $_GET['carte2'], 50);
oci_bind_by_name($procedure, ':retour', $r, 50);

oci_execute($procedure);

?>

