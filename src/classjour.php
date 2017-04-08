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
			<div id= "menu">
				<nav>
					<ul class="top-menu"> <!-- code du menu-->
						<li><a href="index.php">Accueil</a><div class="menu-item" id="item1"></div></li>
						<li><a href="jouer.php">Jouer</a><div class="menu-item" id="item2"></div></li>
						<li><a href="regles.php">Regles</a><div class="menu-item" id="item3"></div></li>
						<li><a href="classement.php">Classement</a><div class="menu-item" id="item4"></div></li>
						<li><a href="historique.php">Historique</a><div class="menu-item" id="item5"></div></li>
						<li><a href="deconnexion.php">Se deconnecter</a><div class="menu-item" id="item6"></div></li>
					</ul>
				</nav>
			</div>
			<table>

				<!-- Début de la liste déroulante pour choisir le classement du niveau que le joueur souhaite voir-->
				<form method="post" action="classjour.php">
					<p>
						<label for="choix">Quel niveau souhaitez vous ?</label><br/>
					
						<select name="choix">
							<?php
							for ($i=1; $i<= 50; $i++) { 
								echo "<option value='$i'>$i</option>"; // ajout des 50 niveaux dans la liste déroulante à l'aide d'une boucle for 
							}
							?>
						</select>
					</p>
					<input type="submit" name="valide" value="Valider"> <!-- bouton valider le choix de l'utilisateur-->
				</form>

				<!-- Tableau du classement du jour, qui sera en trois colonnes: Pseudos, Nombre de coups et Durée -->
				<tr>
				<tr>
					<th>Pseudos</th>
					<th>Nombre de Coups</th>
					<th>Durée</th>
				</tr>

				<?php
				$niveau= $_POST['choix']; // on récupère le choix du niveau que le joueur a fait dans la liste déroulante 
				$classjour = oci_parse($dbConn,'SELECT pseudo,nb_coup,duree FROM vue_highscore_jour WHERE id_niveau=:niv and rownum <= 10 order by rownum');// On récupère nos pseudo, nombre de coup et duree de notre vue pour le classement du jour à travers une requête SQL
				oci_bind_by_name($classjour, ':niv', $niveau,5);
				oci_execute($classjour);
				while(oci_fetch($classjour)){ // Pour chaque ligne de notre requête on:
					$pseudo = oci_result($classjour, 1); // récupère le pseudo de notre requête SQL
					$nbcoup = oci_result($classjour, 2); // récupère le nb coup de notre requête SQL
					$duree = oci_result($classjour, 3); // récupère la durée de notre requête SQL
					print "<tr><td>".$pseudo."</td>"; // et on affiche e pseudo
					print "<td>".$nbcoup."</td>"; // on affiche le nb de coups
					print "<td>".$duree."</td></tr>"; // on affiche la durée de la partie
				}
				?>

			</table>
		</div>
	</body>
</html>
