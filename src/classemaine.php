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
				<nav>
				<!-- Balise nav : regroupe tous les principaux liens de navigation du site-->
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
			<!-- Début de la liste déroulante pour choisir le classement du niveau que le joueur souhaite voir-->
			<form method="post" action="classemaine.php">
				<label for="choix">Quel niveau souhaitez vous ?</label><br/>
					<select name="choix">
						<?php
						// ajout des 50 niveaux dans la liste déroulante à l'aide d'une boucle for
						for ($i=1; $i<= 50; $i++) { 
							echo "<option value='$i'>$i</option>";  
						}
						?>
					</select>
					<input type="submit" name="valide" value="Valider">
			</form>
			<!-- Tableau du classement de la semaine, qui sera en trois colonnes: Pseudos, Nombre de coups et Durée -->
			<table>				
				<tr>
					<th>Pseudos</th>
					<th>Nombre de Coups</th>
					<th>Durée</th>
				</tr>
				<?php
				// on récupère le choix du niveau que le joueur a fait dans la liste déroulante
				$niveau= $_POST['choix']; 
				// On récupère nos pseudo, nombre de coup et duree de notre partie pour le classement de la semaine à travers une requête SQL, seul 10 joueur sont selectionnées 
				$classemai = oci_parse($dbConn,'SELECT pseudo,nb_coup,duree FROM "21602883".vue_highscore_semaine WHERE id_niveau=:niv and rownum <= 10 order by rownum'); 
				oci_bind_by_name($classemai, ':niv', $niveau,5); 
				oci_execute($classemai);
				// Permet de lire chaque ligne de la requête et de :
				while(oci_fetch($classemai)){
					$pseudo = oci_result($classemai, 1); // récupèrer le pseudo
					$nbcoup = oci_result($classemai, 2); // récupèrer le nombre coup 
					$duree = oci_result($classemai, 3); // récupèrer la durée de la partie
					print "<tr>";
						print"<td>".$pseudo."</td>"; // afficher le pseudo
						print "<td>".$nbcoup."</td>"; // afficher le nombre de coups
						print "<td>".$duree."</td>"; // afficher la durée de la partie
					print "<tr>";
				}
				?>

			</table>
		</div>
	</body>
</html>
