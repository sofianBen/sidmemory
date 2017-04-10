<!DOCTYPE html>
<?php
session_start();
include("db/connect.php");

if(isset($_POST['forminscription'])) {

    $mail = htmlspecialchars($_POST['mail']); // htmlspecialchars : remplace les caracteres qui ont une signification particulière en html et on stocke dans la variable $mail le mail saisi
    $mdp = sha1($_POST['mdp']); // shail permet de sécuriser le mdp, on stocke dans la variable $mdp le mot de passe saisi
  //Verifie que tous les champs soient remplis pour stocker les valeurs du formulaire  
  if(!empty($_POST['mail']) AND !empty($_POST['mdp']) ) {
    $mail =$_POST['mail'];
    $mdp = $_POST['mdp']; 
   // Utilisation de la procedure SQL connexion afin de se connecter si la connexion échoue à cause des données saisies par l'utilisateur un message d'erreur est renvoyé
    $reqpseudo = oci_parse($dbConn, 'begin "21602883".connexion(:mail, :mdp, :r); end;'); 
    oci_bind_by_name($reqpseudo, ':mail', $mail,50);
    oci_bind_by_name($reqpseudo, ':mdp', $mdp,50);
    oci_bind_by_name($reqpseudo, ':r', $r, 10);
    oci_execute($reqpseudo);
    oci_free_statement($reqpseudo);
	
    // Si la procédure connexion nous renvoie la valeur 0 alors le joueur se connecte
    if($r == 0) { 
      // Récupération grâce à une requête SQL l'identifiant du joueur à partir de l'email du joueur  
      $id =  oci_parse($dbConn,'select id_joueur from "21602883".Joueur where mail = :mail');
		  oci_bind_by_name($id, ':mail', $_POST['mail'],50);
		  oci_execute($id);
		  while(oci_fetch($id)){
			 $idjoueur = oci_result($id,1);
		  }
		  // on stocke dans la mémoire de la session l'id du joueur qui est connecté
		  $_SESSION['id'] = $idjoueur; 
		  header("Location: index.php"); // permet de rediriger le joueur sur la page d'acceuil (index.php) quand la connexion ne rencontre aucun problème
    }
    // Si la procédure connexion nous renvoie la valeur 1, c'est que le mot de passe a été mal saisi.
    else if($r == 1){
      $erreur = " Connexion non autorisée: Mot de passe invalide ";
    }
    // Si la procédure connexion nous renvoie la valeur 2, c'est que l'email est inconnu dans la base de donnée
    else if($r == 2){
      $erreur = " Connexion non autorisée: adresse mail inconnue";
    }
    // Si la procédure connexion nous renvoie ni 0, ni 1 et ni 2, c'est qu'il s'agit d'une erreur inconnu     
    else{ 
      $erreur = " Erreur ! ";
    }
  }
  // Si tous les champs n'ont pas été remplis alors un message d'erreur qui s'affiche
  else { 
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
      <div id= "menu">
        <nav>
	  <!-- Affiche un menu avec deux onglets: inscription et connexion-->
          <ul class="top-menu"> 
            <li><a href="inscription.php">S'inscrire</a><div class="menu-item" id="item5"></div></li>
            <li><a href="connexion.php">Se connecter</a><div class="menu-item" id="item6"></div></li>
          </ul>
        </nav>
      </div>

      <h2>Connexion</h2>
      
      <!-- formulaire de connexion -->
      <form method="POST" action=""> 
        <table>
          <tr>
            <td id="formu">
              <label for="mail">Mail :</label>
            </td>
            <td>
	      <!-- champ à remplir pour le mail-->
              <input type="text" placeholder="Votre mail" id="mail" name="mail" value="<?php if(isset($mail)) { echo $mail; } ?>"/>
            </td>
          </tr>
          <tr>
            <td>
              <label for="mdp">Mot de passe :</label>
            </td>
            <td>
	      <!-- champ à remplir pour le mot de passe-->
              <input type="password" placeholder="Votre mot de passe" id="mdp" name="mdp" /> 
            </td>
          </tr>
          <tr>
            <td>
              <br/>
	      <!-- bouton pour valider son formulaire-->
              <input type="submit" id="valide" name="forminscription" value="Se connecter" /> 
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
