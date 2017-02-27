<!DOCTYPE html>

<?php
include("db/connect.php");
?>
<html>
  <head>
    <title> Jeu: Memory </title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src = "index.js"></script>

    <link rel="stylesheet" href="bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="index.css">
  </head>

  <body>
    <div id = "base">
      <h1 class = "centrer"> Memory </h1>

        <!-- code du menu -->
        <?php include("menu.php"); ?>
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
