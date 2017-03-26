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

$nivMax =  oci_parse($dbConn,'begin :r := niveauJoueur(:id); end;'); // obtenir le niveau du joueur
oci_bind_by_name($nivMax, ':id', $_SESSION['id'],10);
oci_bind_by_name($nivMax, ':r', $nivJ,10);
oci_execute($nivMax);
		
?>
<html>
	<head>
		<title> Jeu: Memory </title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script src="index.js"></script>
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
            			<li><a href="deconnexion.php">Deconnection</a><div class="menu-item" id="item5"></div></li>
         	 	</ul>
       		</nav>
     		</div>
		<table>
		
		</br>
		</br>
		
		<form method="post" action="sologame.php">
		<?php

		$g=0;
//Creation d'un formulaire qui affiche les niveaux via des boutons submit : grille 5*10
		for ($ii=0; $ii<5 ; $ii++) { 
			echo"<tr>";
			for ($jj=0; $jj<10; $jj++) { 
				$g++;
				if ($g <= $nivJ) { 
					echo"<td> <input type=\"submit\" name ='$g' value ='$g' id=$g /> </td>";
				}else {
					echo"<td>   $g  </td>";
				}

			} 
			echo"</tr>";
		
		} 
		?>
		</form>
		
		</table>
	</body>
</html>

