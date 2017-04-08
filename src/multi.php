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

if(isset($_POST['forminscription'])) {
	$mail = htmlspecialchars($_POST['mail']); // htmlspecialchars l'utilisateur ne peut pas mettre de balise et on stocke dans la variable $mail le mail saisi
    $mdp = sha1($_POST['mdp']); // shail permet de sécuriser le mdp, on stocke dans la variable $mdp le mot de passe saisi
  if(!empty($_POST['mail']) AND !empty($_POST['mdp']) ) { // si tout les champs sont remplis alors:
    $mail = $_POST['mail'];
    $mdp = $_POST['mdp'];
    
    $reqpseudo = oci_parse($dbConn, 'begin connexion(:mail, :mdp, :r); end;');// requête SQL pour utiliser la procédure de la connexion qui nous permet de se connecter ou d'afficher un message d'erreur si problème dans les données saisies par le joueur2
    oci_bind_by_name($reqpseudo, ':mail', $mail,50);
    oci_bind_by_name($reqpseudo, ':mdp', $mdp,50);
    oci_bind_by_name($reqpseudo, ':r', $r, 10);
    oci_execute($reqpseudo);
    oci_free_statement($reqpseudo);
      
    $erreur = $r;

    if($r == 0) { // si la procédure connexion à renvoyer un retour=0 alors le joueur2 peut se connecter
      $idj2 =  oci_parse($dbConn,'select id_joueur from Joueur where mail = :mail'); // requête SQL pour récupérer l'id du joueur2 car il se connecte avec son mail
      oci_bind_by_name($idj2, ':mail', $_POST['mail'],50);
      oci_execute($idj2);
      while(oci_fetch($idj2)){
        $idjoueur2 = oci_result($idj2,1);
      }
      $_SESSION['id2'] = $idjoueur2; // on stocke dans la mémoire de la session l'id du joueur2 qui est connecté
      header("Location: grillemulti.php"); // permet de rediriger le joueur sur la grille de niveau pour jouer une partie multi
    }
    else if($r == 1){ // si la procédure connexion à renvoyer un retour=1 alors le mot de passe saisi est mauvais
      $erreur = " Connexion non autorisée: Mot de passe invalide ";
    }
    else if($r == 2){ // si la procédure connexion à renvoyer un retour=2 alors le mail saisi est mauvais
      $erreur = " Connexion non autorisée: adresse mail inconnue";
    }
    else{ // si la procédure connexion à renvoyer un retour différent de 0,1 et 2 alors on affiche qu'il s'agit d'une erreur inconnu s
      $erreur = " Erreur ! ";
    }
  } 
  else { // si tout les champs n'ont pas été remplis alors message d'erreur qui s'affiche 
    $erreur = "Tous les champs doivent être complétés !";
  }
}

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
      <div id= "menu"> <!-- code du menu -->
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

      <h2>Connexion</h2>
      <br /><br />

      <form method="POST" action=""> <!-- formulaire de connexion -->
        <table>
          <tr>
            <td align="right">
              <label for="mail">Mail :</label>
            </td>
            <td>
              <input type="text" placeholder="Votre mail" id="mail" name="mail" value="<?php if(isset($mail)) { echo $mail; } ?>" /> <!-- champ à remplir pour le mail-->
            </td>
          </tr>
          <tr>
            <td align="right">
              <label for="mdp">Mot de passe :</label>
            </td>
            <td>
              <input type="password" placeholder="Votre mot de passe" id="mdp" name="mdp" /> <!-- champ à remplir pour le mot de passe-->
            </td>
          </tr>
          <tr>
            <td align="center">
              <br />
              <input type="submit" name="forminscription" value="Se connecter" /> <!-- bouton pour valider son formulaire-->
            </td>
          </tr>
        </table>
      </form>
      <!-- Affichage le message d'erreur-->
      <?php
      if(isset($erreur)) {
        echo $erreur;
      }
      ?>
    </div>
  </body>

</html>
