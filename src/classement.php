<!DOCTYPE html>

<?php
//Permet de rester connecter à la base de données
session_start();
include("db/connect.php");

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
      <!-- Affichage de la barre menu en haut de la page -->
      <div id= "menu">
	 <!-- Balise nav : regroupe tous les principaux liens de navigation du site-->
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
      <!-- bouton qui nous redirige vers le classement global-->
      <p>  <a href="classglobal.php" class="bouton">Classement global </a></p>
      <!-- bouton qui nous redirige vers le classement de la semaine-->
      <p> <a href="classemaine.php" class="bouton">Classement semaine </a></p>
      <!-- bouton qui nous redirige vers le classement du jour-->
      <p> <a href="classjour.php" class="bouton">Classement du jour </a></p>
    </div>
  </body>
</html>
