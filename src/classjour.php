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
				
				<form method="post" action="classjour.php">
					<p>
						<label for="choix">Quel niveau souhaitez vous ?</label><br/>
					
						<select name="choix">
							<?php
							for ($i=1; $i<= 50; $i++) { 
								echo "<option value='$i'>$i</option>";
							}
							?>
						</select>
					</p>
					<input type="submit" name="valide" value="Valider">
				</form>

				<tr>
					<th>Pseudos</th>
					<th>Nombre de Coups</th>
					<th>Durée</th>
				</tr>

				<?php
				$niveau= $_POST['choix'];
				$classjour = oci_parse($dbConn,'SELECT pseudo,nb_coup,duree FROM vue_highscore_jour WHERE id_niveau=:niv and rownum <= 10 order by rownum');
				oci_bind_by_name($classjour, ':niv', $niveau,5);
				oci_execute($classjour);
				while(oci_fetch($classjour)){
					$pseudo = oci_result($classjour, 1);
					$nbcoup = oci_result($classjour, 2);
					$duree = oci_result($classjour, 3);
					print "<tr><td>".$pseudo."</td>";
					print "<td>".$nbcoup."</td>";
					print "<td>".$duree."</td></tr>";
				}
				?>

			</table>
		</div>
	</body>
</html>
