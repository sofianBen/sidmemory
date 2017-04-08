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
$nivMax =  oci_parse($dbConn,'begin :r := niveau_Joueur(:id); end;'); // requête SQL pour utiliser la fonction niveau_Joueur qui nous permet d'obtenir le niveau du joueur
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
      		<div id= "menu">
        		<nav>
        	  		<ul class="top-menu"> <!-- code du menu -->
        	   			<li><a href="index.php">Accueil</a><div class="menu-item" id="item1"></div></li>
						<li><a href="jouer.php">Jouer</a><div class="menu-item" id="item2"></div></li>
						<li><a href="regles.php">Regles</a><div class="menu-item" id="item3"></div></li>
						<li><a href="classement.php">Classement</a><div class="menu-item" id="item4"></div></li>
						<li><a href="historique.php">Historique</a><div class="menu-item" id="item5"></div></li>
						<li><a href="deconnexion.php">Se deconnecter</a><div class="menu-item" id="item6"></div></li>
         	 		</ul>
       			</nav>
     		</div>
				
			</br> <!-- saut de ligne-->
			</br>

			<table> <!-- Tableau avec tout les niveaux -->
		
				<form method="post" action="sologame.php"> <!-- formulaire qui redirigera vers la partie du niveau sélectionner (sologame.php) -->
				<?php
					$g=0;
					for ($ii=0; $ii<5 ; $ii++) { 
						echo"<tr>";
						for ($jj=0; $jj<10; $jj++) { 
							$g++;
							if ($g <= $nivJ) { // notre variable g est inférieur au niveau du joueurs alors on ajoute 
								echo"<td> <input type=\"submit\" name =\"niveau\" value ='$g' id=$g /> </td>"; // un bouton pour chaque niveau
							}
							else {
								echo"<td> $g </td>"; // sinon on ajoute juste le niveau sans bouton 
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
