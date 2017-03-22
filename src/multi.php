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

   $mail = htmlspecialchars($_POST['mail']);
   $mdp = sha1($_POST['mdp']); // permet de sécuriser le mdp

   if(!empty($_POST['mail']) AND !empty($_POST['mdp']) ) {

     $mail = $_POST['mail'];
     $mdp = $_POST['mdp'];

     $reqpseudo = oci_parse($dbConn, 'begin connexion(:mail, :mdp, :r); end;');

     oci_bind_by_name($reqpseudo, ':mail', $mail,50);
     oci_bind_by_name($reqpseudo, ':mdp', $mdp,50);
     oci_bind_by_name($reqpseudo, ':r', $r, 10);

     oci_execute($reqpseudo);

     oci_free_statement($reqpseudo);
     $erreur = $r;

     if($r == 0) {
     $_SESSION['id'] = $userinfo['id'];
     $_SESSION['pseudo'] = $userinfo['pseudo'];
     header("Location: jouermulti.php");
     }
     else if($r == 1){
     $erreur = " Connexion non autorisée: Mot de passe invalide ";
     }
     else if($r == 2){
     $erreur = " Connexion non autorisée: adresse mail inconnue";
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
    <script src = "index.js"></script>

    <link rel="stylesheet" href="index.css">
  </head>

  <body>
    <div id = "base">
      <h1 class = "centrer"> Memory </h1>

      <div id= "menu">
        <nav>
          <ul class="top-menu">
            <li><a href="index.php">Accueil</a><div class="menu-item" id="item1"></div></li>
            <li><a href="jouer.php">Jouer</a><div class="menu-item" id="item2"></div></li>
            <li><a href="regles.php">Regles</a><div class="menu-item" id="item3"></div></li>
            <li><a href="classement.php">Classement</a><div class="menu-item" id="item4"></div></li>
            <li><a href="deconnexion.php">Déconnexion</a><div class="menu-item" id="item5"></div></li>
          </ul>
        </nav>
      </div>

      <h2>Connexion</h2>
      <br /><br />

      <form method="POST" action="">
        <table>
          <tr>
            <td align="right">
              <label for="mail">Mail :</label>
            </td>
            <td>
              <input type="text" placeholder="Votre mail" id="mail" name="mail" value="<?php if(isset($mail)) { echo $mail; } ?>" />
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
              <input type="submit" name="forminscription" value="Se connecter" />
            </td>
          </tr>
        </table>
      </form>
      <?php
      if(isset($erreur)) {
        echo $erreur;
      }
      ?>

    </div>
  </body>

</html>
