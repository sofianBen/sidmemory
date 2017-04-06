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
	
echo $niveau;

$reqpartie = oci_parse($dbConn, 'begin creation_partie_multi(:pId_niveau, :pId_joueur1, :pId_joueur2, :rId_partie); end;');

oci_bind_by_name($reqpartie, ':pId_niveau', $niveau,5);
oci_bind_by_name($reqpartie, ':pId_joueur1', $_SESSION['id'],50);
oci_bind_by_name($reqpartie, ':pId_joueur2', $_SESSION['id2'],50);
oci_bind_by_name($reqpartie, ':rId_partie', $id_partie, 50);

oci_execute($reqpartie);
oci_free_statement($reqpartie);

/*$idJ1 = oci_parse($dbConn,'SELECT id_Joueur FROM Partie P where P.id_partie =:id_partie');
oci_bind_by_name($idJ1, ':partie', $id_partie, 50);
oci_execute($idJ1);
while(oci_fetch($idJ1)){
	$idJoueur1 = oci_result($idJ1,1);
}
$pseudoJ1 =  oci_parse($dbConn,'begin :pseudo := id_Joueur_en_pseudo(:idJ1); end;'); // obtenir le niveau du joueur
		oci_bind_by_name($pseudoJ1, ':idJ1', $_SESSION['id'],50);
		oci_bind_by_name($pseudoJ1, ':pseudo', $pJ1,50);
		oci_execute($pseudoJ1);*/

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
		<script src="index.js"></script>
		<link rel="stylesheet" href="index.css">
    <script type="text/javascript">
    
	var nbCarte=0;
	var image1;
	var image2;	
 	var nbCoups=0; 
	var Joueur1 = 1; 
	var Joueur2 = 0;
	var Joueur = 1;
	var nbPaireJoueur1 = 0; 
	var nbPaireJoueur2 = 0;
	var nbPaireMax=0 ;	

//Entré : identifiant de la carte (id) et la source de l'image qui doit être dessous (src)
//L'utilisateur clique sur une carte si c'est la première carte qui joue elle se retourne, 
//si c'est la deuxième on vérifie qu'il ne s'agit de la même que la première si c'est le cas l'utilisateur doit en choisir une autre sinon elle se retourne et déclanche la fonction paire
//Sortie : Deux cartes retournées

	function jouer(a,src,nbPaire) {
		nbPaireMax=nbPaire;
		// recup pour a + le numero de ligne et colonne où il a clique
		// alle sur la bd et cherche quelle est la source dans cette ligne et colonne
		nbCarte ++;
		if(nbCarte == 1 ){
			image1 = document.getElementById(a.id);
			image1.src = src;
		}
		else if ( (nbCarte == 2) && (document.getElementById(a.id)!= image1)){
			image2= document.getElementById(a.id);
			image2.src = src;
			window.setTimeout("paire()",1000);			
		}
		else{
			nbCarte=nbCarte-1;
		}
	}

	function paire(){
		if( image1.src == image2.src){
			image1.onclick="none";
			image2.onclick="none";
			image1.src = "PaireTrouvee.png";
			image2.src = "PaireTrouvee.png";
			image1.alt = "Paire Trouvée";
			image2.alt = "Paire Trouvée";
			if (Joueur == Joueur1){
				nbPaireJoueur1 += 1; 
			}else{
				nbPaireJoueur2 += 1; 
			}
			finParti(nbPaireJoueur1,nbPaireJoueur2);
			
		}
		else{
			image1.src = "face_cache.jpg";
			image2.src = "face_cache.jpg";
			if (Joueur == Joueur1){
				Joueur = 0;
				alert("C'est au joueur2 de jouer");
			}else {
				Joueur = 1;
				alert("C'est au joueur1 de jouer");
			}
		}
		nbCoups ++;
		nbCarte=0;
	}

	function finParti(nbPaireJ1, nbPaireJ2){
		var nbPaireJouee;
		nbPaireJouee = nbPaireJ1 + nbPaireJ2; 
		if (nbPaireJouee == nbPaireMax) {
			if(nbPaireJ1 > nbPaireJ2){
				alert("La partie est fini, le joueur1 a gagné");
			}
			else if(nbPaireJ2 > nbPaireJ1){
				alert("La partie est fini, le joueur2 a gagné");
			}
			else {
				alert("La partie est fini, égalité");
			}
		} 
		
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
			echo"<td> <img id='$g' height=\"100px\" width=\"100px\" alt= \"Memory\" src = \"face_cache.jpg\" width = \"100\" onclick=\"jouer(this,'$src','$nbPaireMax')\"> </td>";
		} 
		echo"</tr>";
	}
	?>
	</table>

  </body>
</html>
