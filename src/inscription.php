<!DOCTYPE html>
<?php

include("db/connect.php");

$strSQL = "select * FROM joueur";

$stmt = oci_parse($dbConn,$strSQL);
if ( ! oci_execute($stmt) ){
$err = oci_error($stmt);
trigger_error('Query failed: ' . $err['message'], E_USER_ERROR);
};

if(isset($_POST['forminscription'])) {
   $pseudo = htmlspecialchars($_POST['pseudo']); // htmlspecialchars: l'utilisateur ne peut pas mettre de balise
   $mail = htmlspecialchars($_POST['mail']);
   $mdp = sha1($_POST['mdp']); // permet de sécuriser le mdp

   if(!empty($_POST['pseudo']) AND !empty($_POST['mail']) AND !empty($_POST['mdp']) ) { // si tout est rempli alors:
     $ps = $_POST['pseudo'];
     $mail = $_POST['mail'];
     $mdp = $_POST['mdp'];

     $reqpseudo = oci_parse($dbConn, 'begin inscription(:ps, :mail, :mdp, :r); end;'); // appel à la procédure inscription

     oci_bind_by_name($reqpseudo, ':ps', $ps,50);
     oci_bind_by_name($reqpseudo, ':mail', $mail,50);
     oci_bind_by_name($reqpseudo, ':mdp', $mdp,50);
     oci_bind_by_name($reqpseudo, ':r', $r, 10); // la variable r est la variable retour de notre procédure

     oci_execute($reqpseudo);

     oci_free_statement($reqpseudo);

     if($r == 0) {
     $erreur = " Bravo vous êtes inscrit ! ";
     }
     else if($r == 1){
     $erreur = " L'adresse mail est déja utilisée, veuillez en choisir une autre ";
     }
     else if($r == 2){
     $erreur = " L'adresse mail est invalide, veuillez la corriger";
     }
     else{
     $erreur = " Erreur ! ";
     }

   } else {
      $erreur = "Tous les champs doivent être complétés !";
   }
}
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
      <div id= "menu">
        <nav>
          <ul class="top-menu"> <!-- Barre de menu --> 
            <li><a href="inscription.php">S'inscrire</a><div class="menu-item" id="item5"></div></li>
            <li><a href="connexion.php">Se connecter</a><div class="menu-item" id="item6"></div></li>
          </ul>
        </nav>
      </div>
      <h2>Inscription</h2>
      <br /><br />

      <form method="POST" action=""> <!-- Formulaire d'inscription --> 
        <table>
          <tr>
            <td align="right">
              <label for="pseudo">Pseudo :</label>
            </td>
            <td>
              <input type="text" placeholder="Votre pseudo" id="pseudo" name="pseudo" value="<?php if(isset($pseudo)) { echo $pseudo; } ?>" />
            </td>
          </tr>
          <tr>
            <td align="right">
              <label for="mail">Mail :</label>
            </td>
            <td>
              <input type="email" placeholder="Votre mail" id="mail" name="mail" value="<?php if(isset($mail)) { echo $mail; } ?>" />
            </td>
          </tr>
          <tr>
            <td align="right">
              <label for="mdp">Mot de passe :</label>
            </td>
            <td>
              <input type="password" placeholder="Votre mot de passe" id="mdp" name="mdp" />
            </td>
          </tr>
          <tr>
            <td align="center">
              <br />
              <input type="submit" name="forminscription" value="Je m'inscris" />
            </td>
          </tr>
        </table>
      </form> <!-- On affiche un message d'erreur --> 
      <?php
      if(isset($erreur)) {
        echo $erreur;
      }
      ?>
    </div>
  </body>
</html>
