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
						<li><a href="deconnexion.php">Se deconnecter</a><div class="menu-item" id="item6"></div></li>          </ul>
        </nav>
      </div>

      <h2>Les règles</h2>
      <p>
        Pour débuter la partie, déposer toutes les cartes mélangées face contre table de façon à ce que les images ne soient pas visibles.
        Le premier joueur découvre 2 cartes, si elles sont identiques, il les remporte sinon il les cache à nouveau.
        C'est ensuite au joueur suivant de retourner 2 cartes et ainsi de suite...
        Le but étant de tenter de mémoriser l'emplacement des différentes cartes afin de retourner successivement les 2 cartes identiques formant la paire pour les remporter.
        Quand le joueur remporte une paire, cela lui donne le droit de rejouer.
        La partie est terminée quand toutes les paires ont été trouvées.
        Le joueur qui a remporté le plus de cartes a gagné la partie.
      </p>
    </div>
  </body>

</html>
