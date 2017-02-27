<!DOCTYPE html>

<?php
include("db/connect.php");
?>

<html>
  <head>
    <title> Jeu: Memory </title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="index.js"></script>


    <link rel="stylesheet" href="index.css">
  </head>

  <body>
    <div id = "base">
      <h1 class = "centrer"> Memory </h1>
      <!-- code du menu -->

      <div id= "menu">
         <?php include("menu.php"); ?>
      </div>
      <img src = "memory.jpg" width = 400 alt="memory">

      <div id = "milieu" class = "centrer">
        <div id = "centre">
          <p class = "centrer"><strong>Créateurs</strong>: Céline, Claire, Camille et Sofian</p>
          <p class = "centrer"> Etudiant de  l'Université Paul Sabatier (<a href="https://www.google.fr/maps/place/120+rue+de+Narbonne+31400+toulouse" target="_blank">plan</a>)</p>
        </div>
      </div>
    </div>
  </body>
</html>
