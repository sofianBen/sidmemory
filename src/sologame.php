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

$Ligne=  oci_parse($dbConn,'SELECT nb_ligne FROM Partie P, Niveau  N where id_partie =1 and P.id_Niveau = N.id_Niveau');
oci_execute($Ligne);

while(oci_fetch($Ligne)){			
	$LigneMax = oci_result($Ligne,1);
}

$Colonne=  oci_parse($dbConn,'SELECT nb_colonne FROM Partie P, Niveau  N where id_partie =1 and P.id_Niveau = N.id_Niveau');
oci_execute($Colonne);
while(oci_fetch($Colonne)){			
	$ColonneMax = oci_result($Colonne,1);
}
		
?> 

<html>
	<head>
		<title> Jeu: Memory </title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script src="index.js"></script>
		<link rel="stylesheet" href="index.css">
    <script type="text/javascript">
    
    var nbCarte=0;
    var image1;
    var image2;	
    var nbCoups=0;
	
	function jouer(a) {
		// recup pour a + le numero de ligne et colonne où il a clique
		// alle sur la bd et cherche quelle est la source dans cette ligne et colonne
		nbCarte ++;
		if(nbCarte == 1 ){
			image1 = document.getElementById(a.id);
			image1.src = "bleu_rond.png";
		}
		else if ( (nbCarte == 2) && (document.getElementById(a.id)!= image1)){
			image2= document.getElementById(a.id);
			image2.src = "rouge_rond.png";
			window.setTimeout("deuxieme_coup()",1000);
			//timer
			// lancer timer = 0sec
			// When timer = 2sec alors :			
		}
		else{
			nbCarte=nbCarte-1;
		}
	}

	function deuxieme_coup(){
		if( image1.src == image2.src){
			image1.onclick="none";
			image2.onclick="none";
			nbCarte=0;
			nbCoups ++;
		}
		else{
			image1.src = "face_cache.jpg";
			image2.src = "face_cache.jpg";
			nbCarte=0;
			nbCoups ++; 
		}
	}

	function nombre_coup(){
		return nbCoups;
	}
    </script>
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

	</br>
	</br>
  	<table>
	<?php
	// lancer une procedure qui remplis pour l'id partie aléatoirement l'emplacement des cartes
	// récuperer à travers cette procedure, l'id partie pour ensuite faire un select sur cet id partie
	$g=0;
	// recuperer le niveau, nb de ligne et colonnes
	for ($i=0; $i< $LigneMax; $i++) { 
	echo"<tr>";	
		for ($j=0; $j< $ColonneMax; $j++) { 
			$g++;

			echo"<td> <img id='$g' alt= \"social logo\" src = \"face_cache.jpg\" width = \"100\" onclick=\"jouer(this)\"> </td>";
		} 
	echo"</tr>";
	} // fin for
	?>
	</table>
    nb=nombre_coup();
    <p> Nombre de coups = nbcoups </p>
  </body>
  
</html>
