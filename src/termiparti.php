<?php
require("db/connect.php");

$procedure = oci_parse($dbConn, 'call terminer_partie(:p_idpartie, :retour)');

oci_bind_by_name($procedure, ':p_idpartie', $_GET['idpartie'],5);
oci_bind_by_name($procedure, ':retour', $r, 50);

oci_execute($procedure);

?>
