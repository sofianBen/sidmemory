<?php
require("db/connect.php");

// utilisation de la procedure insert_coup pour ajouter un coup dans la BD
$procedure = oci_parse($dbConn, 'call insert_coup(:p_idpartie, :p_idjoueur, :p_carte1, :p_carte2,:retour)');

oci_bind_by_name($procedure, ':p_idpartie', $_GET['idpartie'],5); // $_GET['idpartie']: on récupère l'idpartie de notre fonction ajax
oci_bind_by_name($procedure, ':p_idjoueur', $_GET['idjoueur'],10); // $_GET['idjoueur']: on récupère l'idjoueur de notre fonction ajax
oci_bind_by_name($procedure, ':p_carte1', $_GET['carte1'], 10); // $_GET['carte1']: on récupère l'idjoueur de notre fonction ajax
oci_bind_by_name($procedure, ':p_carte2', $_GET['carte2'], 10); // $_GET['carte2']: on récupère l'idjoueur de notre fonction ajax
oci_bind_by_name($procedure, ':retour', $r, 50);

oci_execute($procedure);

?>

