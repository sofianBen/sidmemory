<!DOCTYPE html>

<?php
session_start();

include("db/connect.php");

$strSQL = "select * FROM joueur";

$stmt = oci_parse($dbConn,$strSQL);
if ( ! oci_execute($stmt) ){
$err = oci_error($stmt);
trigger_error('Query failed: ' . $err['message'], E_USER_ERROR);
};

?>

<html>

  <head>
    <title> Jeu: Memory </title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="index.css">
  </head>

  <body>
    <div id = "base">
      <h1 class = "centrer"> Memory </h1>
<!-- code du menu -->
      <div id= "menu">
        <nav>
          <ul class="top-menu">
            <li><a href="index.php">Accueil</a><div class="menu-item" id="item1"></div></li>
						<li><a href="jouer.php">Jouer</a><div class="menu-item" id="item2"></div></li>
						<li><a href="regles.php">Regles</a><div class="menu-item" id="item3"></div></li>
						<li><a href="classement.php">Classement</a><div class="menu-item" id="item4"></div></li>
						<li><a href="historique.php">Historique</a><div class="menu-item" id="item5"></div></li>
						<li><a href="deconnexion.php">Se deconnecter</a><div class="menu-item" id="item6"></div></li>
          </ul>
        </nav>
      </div>
      </br>
      </br>
      <p>
      	<a href="grillemono.php" class="bouton">Partie Mono-joueur </a> <!-- bouton pour rediriger vers la partie mono-joueur(grillemono.php) -->
      </p>
      <p>
      	<a href="multi.php" class="bouton">Partie Multijoueurs </a> <!-- bouton pour rediriger vers la partie multijoueur(multi.php) -->
      </p>
    </div>
  </body>

</html>
