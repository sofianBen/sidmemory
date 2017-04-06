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

$niveau= $_POST['niveau'];
$id_j1=$_SESSION['id'];
$id_j2=$_SESSION['id2'];


echo $niveau;

$reqpartie = oci_parse($dbConn, 'begin creation_partie_multi(:pId_niveau, :pId_joueur1, :pId_joueur2, :rId_partie); end;');

oci_bind_by_name($reqpartie, ':pId_niveau', $niveau,5);
oci_bind_by_name($reqpartie, ':pId_joueur1', $_SESSION['id'],50);
oci_bind_by_name($reqpartie, ':pId_joueur2', $_SESSION['id2'],50);
oci_bind_by_name($reqpartie, ':rId_partie', $id_partie, 50);

oci_execute($reqpartie);
oci_free_statement($reqpartie);

$Ligne=  oci_parse($dbConn,'SELECT nb_ligne FROM Partie P, Niveau  N where P.id_partie =:partie and P.id_Niveau = N.id_Niveau');
oci_bind_by_name($Ligne, ':partie', $id_partie, 50);
oci_execute($Ligne);
while(oci_fetch($Ligne)){
	$LigneMax = oci_result($Ligne,1);
}

$Colonne=  oci_parse($dbConn,'SELECT nb_colonne FROM Partie P, Niveau  N where P.id_partie =:part and P.id_Niveau = N.id_Niveau');
oci_bind_by_name($Colonne, ':part', $id_partie, 50);
oci_execute($Colonne);
while(oci_fetch($Colonne)){
	$ColonneMax = oci_result($Colonne,1);
}
echo $ColonneMax;
echo $LigneMax;
$nbPaireMax= ($LigneMax*$ColonneMax)/2;		
?>

<html>
	<head>
		<title> Jeu: Memory </title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<link rel="stylesheet" href="index.css">
		<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"> </script>
		<script src="srcmulti.js"></script>
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
		<?php 
			echo"<p> Joueur 1 :  			 Joueur 2 :  </p>";

		?> 
     		</div>

	</br>
	</br>
	
  	<table>
	<?php
	// lancer une procedure qui remplis pour l'id partie aléatoirement l'emplacement des cartes
	// récuperer à travers cette procedure, l'id partie pour ensuite faire un select sur cet id partie
	$g=0;
	// recuperer le niveau, nb de ligne et colonnes
	for ($i=1; $i<=$LigneMax; $i++) { 
		echo"<tr>";	
		for ($j=1; $j<= $ColonneMax; $j++) { 
			$g++;
			
			$reqsrc =  oci_parse($dbConn,'SELECT lien FROM CARTE C, IMAGE I, PARTIE P where C.ligne = :l and C.colonne = :c and P.id_partie = :p and P.id_partie=C.id_partie and I.id_image=C.id_image ');

			oci_bind_by_name($reqsrc, ':l', $i,5);
			oci_bind_by_name($reqsrc, ':c', $j,5);
			oci_bind_by_name($reqsrc, ':p', $id_partie, 50);
			oci_execute($reqsrc);
			while(oci_fetch($reqsrc)){
				$src = oci_result($reqsrc,1);
			}
			echo"<td> <img id='$g' height=\"100px\" width=\"100px\" alt= \"Memory\" src = \"face_cache.jpg\" width = \"100\" onclick=\"jouer(this,'$src','$nbPaireMax','$id_partie','$id_j1','$id_j2')\"> </td>";
		} 
		echo"</tr>";
	}
	?>
	</table>

  </body>
</html>
