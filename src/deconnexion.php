<?php
session_start();
$_SESSION = array();
session_destroy(); // ferme la session du joueur
header("Location: inscription.php") // permet de retourner sur la page d'inscription (inscription.php)
 ?>
