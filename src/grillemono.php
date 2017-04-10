<!DOCTYPE html>
<?php
//Permet de rester connecter à la base de données
session_start();
include("db/connect.php");
// Utilisation de la procédure niveau_joueur pour obtenir le niveau du joueur à partir de son identifiant
$nivMax =  oci_parse($dbConn,'begin :r := "21602883".niveau_Joueur(:id); end;');
		oci_bind_by_name($nivMax, ':id', $_SESSION['id'],10);
		oci_bind_by_name($nivMax, ':r', $nivJ,10);
		oci_execute($nivMax);		
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
				<!-- Balise nav : regroupe tous les principaux liens de navigation du site -->
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
			<!-- Tableau avec tout les niveaux -->
			<table> 
				<!-- formulaire qui redirigera vers la partie du niveau sélectionner (sologame.php) -->
				<form method="post" action="sologame.php">
				<?php
					$g=0;
					for ($ii=0; $ii<5 ; $ii++) { 
						echo"<tr>";
						for ($jj=0; $jj<10; $jj++) { 
							$g++;
							if ($g <= $nivJ) { 
								// Si notre variable $g est inférieur au niveau du joueurs, on créee un bouton pour que le joueur  
								echo"<td> <input type=\"submit\" name =\"niveau\" value ='$g' id=$g /> </td>";
							}
							else {	
								// Sinon on affiche le niveau sans qu'il puisse cliquer dessus
								echo"<td> $g </td>"; 
							}
						} 
						echo"</tr>";
					} 
				?>
				</form>
			</table>
		</div>
	</body>
</html>
