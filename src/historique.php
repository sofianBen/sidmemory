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
			<!-- code du menu -->
			<div id= "menu">
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
			<table>
				
				<form method="post" action="historevoir.php"><!-- formulaire pour connaître la partie que le joueur veut voir qui renverra vers la page où on choisit le coup que l'on souhaite revoir(historevoir.php) -->
					<p>
						<label for="choix">Quelle partie souhaitez vous revoir?</label><br/>
					
						<select name="choix">
							<?php
							// requête SQL pour récupérer tout les id_partie que le joueur a joué
							$choixpartie = oci_parse($dbConn,'SELECT id_partie FROM Partie WHERE id_joueur=:idj order by id_partie asc');
							oci_bind_by_name($choixpartie, ':idj', $_SESSION['id'],5);
							oci_execute($choixpartie);
							while(oci_fetch($choixpartie)){
								$idpartie = oci_result($choixpartie, 1);
								echo "<option value='$idpartie'>$idpartie</option>";
							}
							?>
						</select>
					</p>
					<input type="submit" name="valide" value="Valider"> <!-- bouton pour valider le choix du joueur -->
				</form>
			</table>
		</div>
	</body>
</html>
