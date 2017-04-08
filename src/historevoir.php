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

$id_j= $_SESSION['id']; // on stocke l'id du joueur dans la varaible $id_j
$_SESSION['idpart']= $_POST['choix']; // on obtient le choix du niveau de la partie du joueur et on le stocke dans la session du joueurs
$id_p= $_SESSION['idpart']; // on stocke l'id de la partie selectionnre dans la varaible $id_p

$Ligne=  oci_parse($dbConn,'SELECT nb_ligne FROM Partie P, Niveau  N where P.id_partie =:partie and P.id_Niveau = N.id_Niveau');
// requête SQL pour obtenir le nb ligne de la partie qui a été joué
oci_bind_by_name($Ligne, ':partie', $id_p, 50);
oci_execute($Ligne);
while(oci_fetch($Ligne)){
	$LigneMax = oci_result($Ligne,1);
}

$Colonne=  oci_parse($dbConn,'SELECT nb_colonne FROM Partie P, Niveau  N where P.id_partie =:part and P.id_Niveau = N.id_Niveau');
// requête SQL pour obtenir le nb de colonne de la partie qui a été joué
oci_bind_by_name($Colonne, ':part', $id_p, 50);
oci_execute($Colonne);
while(oci_fetch($Colonne)){
	$ColonneMax = oci_result($Colonne,1);
}

$reqnbcoup=oci_parse($dbConn,'begin :r := nb_coup_partie(:pid_partie); end;'); // requête SQL qui fait appele à la fonction nb_coup_partie qui permet d'obtenir le nb de coup de la partie
oci_bind_by_name($reqnbcoup, ':pid_partie', $id_p,10);
oci_bind_by_name($reqnbcoup, ':r', $nbcoup,10);
oci_execute($reqnbcoup);
	
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
           				<li><a href="index.php">Accueil</a><div class="menu-item" id="item1"></div></li>							<li><a href="jouer.php">Jouer</a><div class="menu-item" id="item2"></div></li>
						<li><a href="regles.php">Regles</a><div class="menu-item" id="item3"></div></li>
						<li><a href="classement.php">Classement</a><div class="menu-item" id="item4"></div></li>
						<li><a href="historique.php">Historique</a><div class="menu-item" id="item5"></div></li>
						<li><a href="deconnexion.php">Se deconnecter</a><div class="menu-item" id="item6"></div></li>
         	 		</ul>
       			</nav>
       		</div>
			<form method="post" action="historevoirbis.php"> <!-- formulaire pour connaître le coup que le joueur veut voir qui renverra vers la table avec le coup jouer (historevoirbis.php) -->
				<p>
					<label for="choixcoup">Quel coup souhaitez vous voir?</label>
					<br/>
					<select name="choixcoup">
						<?php
						// requête SQL pour récupérer tout les id_coup de la partie selectionné par le joueur
						$reqcoup = oci_parse($dbConn,'SELECT id_coup FROM Coup WHERE id_partie=:idpartie order by id_coup asc');
						oci_bind_by_name($reqcoup, ':idpartie', $id_p,5);
						oci_execute($reqcoup);
						while(oci_fetch($reqcoup)){
							$idcoup = oci_result($reqcoup, 1);
							echo "<option value='$idcoup'>$idcoup</option>";
						}
						?>
					</select>
				</p>
				<input type="submit" name="valide" value="Valider">  <!-- bouton pour valider le choix du joueur -->
			</form>

  			<table>
				<?php	
				$g=0;		
				// grille de la partie de départ
				for ($i=1; $i<=$LigneMax; $i++) { 
					echo"<tr>";	
					for ($j=1; $j<= $ColonneMax; $j++) { 
					$g++;
					echo"<td> <img id='$g' height=\"100px\" width=\"100px\" alt= \"Memory\" src = \"face_cache.jpg\" width = \"100\" </td>";
					} 
					echo"</tr>";
				}
				?>
			</table>

			<form method='post' action='index.php'> <!-- bouton pour quitter la page, qui vous redirigera vers la page d'acceuil (index.php) -->
				<input type='submit' value='Quitter'>
			</form>
		</div>
	</body>
</html>
