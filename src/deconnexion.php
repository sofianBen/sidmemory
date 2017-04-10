<?php
session_start();
$_SESSION = array();
// ferme la session du joueur
session_destroy(); 
// permet de retourner sur la page d'inscription (inscription.php)
header("Location: inscription.php")
 ?>
