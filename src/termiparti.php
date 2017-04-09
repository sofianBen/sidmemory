<?php
require("db/connect.php");

// utilisation de la procedure terminer_partie qui permet de passer une partie de 'En cours' à 'Terminé'
$procedure = oci_parse($dbConn, 'call "21602883".terminer_partie(:p_idpartie, :retour)');

oci_bind_by_name($procedure, ':p_idpartie', $_GET['idpartie'],5); // $_GET['idpartie']: on récupère l'idpartie de notre fonction ajax
oci_bind_by_name($procedure, ':retour', $r, 50);

oci_execute($procedure);

?>
