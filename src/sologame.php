<!DOCTYPE html>
<?php
session_start();
include("db/connect.php");

$niveau= $_POST['niveau']; // on stocke l'identifiant du niveau selectionner dans notre formulaire ans la varaible $niveau
$id_j=$_SESSION['id']; // on stocke l'identifiant du joueur1 dans la varaible $id_j1


// requête SQL qui fait appel à la requête creation_partie_solo qui permet de créer une partie mono
$reqpartie = oci_parse($dbConn, 'begin "21602883".creation_partie_solo(:pId_niveau, :pId_joueur, :rId_partie); end;');
oci_bind_by_name($reqpartie, ':pId_niveau', $niveau,5);
oci_bind_by_name($reqpartie, ':pId_joueur', $_SESSION['id'],50);
oci_bind_by_name($reqpartie, ':rId_partie', $id_partie, 50);
oci_execute($reqpartie);
oci_free_statement($reqpartie);

//Obtention de la date (avec l'heure) de la fin de la partie 
$rDateFinPartie =  oci_parse($dbConn,'begin :r := "21602883".heure_fin_partie(:idP); end;'); 
oci_bind_by_name($rDateFinPartie, ':idP', $id_partie,50);
oci_bind_by_name($rDateFinPartie, ':r', $dateFinPartie,60);
oci_execute($rDateFinPartie);


// requête SQL pour obtenir le nombre de ligne de la grille du jeu (grâce à l'id_niveau)
$Ligne=  oci_parse($dbConn,'SELECT nb_ligne FROM "21602883".Niveau  N where N.id_Niveau = :niveau');
oci_bind_by_name($Ligne, ':niveau', $niveau, 5);
oci_execute($Ligne);
while(oci_fetch($Ligne)){
	$LigneMax = oci_result($Ligne,1);
}

// requête SQL pour obtenir le nombre de colonne de la grille du jeu (grâce à l'id_niveau)
$Colonne=  oci_parse($dbConn,'SELECT nb_colonne FROM "21602883".Niveau  N where N.id_Niveau = :niveau');
oci_bind_by_name($Colonne, ':niveau', $niveau, 5);
oci_execute($Colonne);
while(oci_fetch($Colonne)){
	$ColonneMax = oci_result($Colonne,1);
}
//Calcul du nombre de paire possible
$nbPaireMax= ($LigneMax*$ColonneMax)/2;	
	
?> 

<html>
	<head>
		<title> Jeu: Memory </title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<link rel="stylesheet" href="index.css">
		<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"> </script> <!-- pour utiliser ajax -->
		<script src="srcsolo.js"></script>

	</head>

	<body>
		<div id = "base">
			<h1 class = "centrer"> Memory </h1>
		<!-- Affichage de la barre menu en haut de la page -->
      			<div id= "menu">
			<!-- Balise nav : regroupe tous les principaux liens de navigation du site. (convention W3C)  -->
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
       			
       			<p id="chrono"></p>
  				<table>
				<?php	
				// affichage de la grille du jeu
				$g=0;
				for ($i=1; $i<=$LigneMax; $i++) { 
					echo"<tr>";	
					for ($j=1; $j<= $ColonneMax; $j++) { 
						$g++;
						$reqsrc =  oci_parse($dbConn,'SELECT lien FROM "21602883".CARTE C, "21602883".IMAGE I, "21602883".PARTIE P where C.ligne = :l and C.colonne = :c and P.id_partie = :p and P.id_partie=C.id_partie and I.id_image=C.id_image ');
						// On récupère la source chaque carte de la partie à travers une requête SQL
						oci_bind_by_name($reqsrc, ':l', $i,5);
						oci_bind_by_name($reqsrc, ':c', $j,5);
						oci_bind_by_name($reqsrc, ':p', $id_partie, 50);
						oci_execute($reqsrc);
						while(oci_fetch($reqsrc)){
							$src = oci_result($reqsrc,1);
						}

						$reqidcarte =  oci_parse($dbConn,'SELECT id_carte FROM  "21602883".CARTE where ligne = :li and colonne = :co and id_partie = :pa');// On récupère l'identifiant de chaque carte de la partie à travers une requête SQL
						oci_bind_by_name($reqidcarte, ':li', $i,5);
						oci_bind_by_name($reqidcarte, ':co', $j,5);
						oci_bind_by_name($reqidcarte, ':pa', $id_partie, 50);
						oci_execute($reqidcarte);
						while(oci_fetch($reqidcarte)){
							$idcarte = oci_result($reqidcarte,1);
						}

						// affichage de l'image d'une carte retourné et si on clique dessus alors appel à la fonction jouer du javascript (srcmono.js)
						echo"<td> <img id='$g' height=\"100px\" width=\"100px\" alt= \"Memory\" src = \"face_cache.jpg\" width = \"100\" onclick=\"jouer(this,'$src','$nbPaireMax','$id_partie','$id_j','$idcarte')\"> </td>";
					} 
					echo"</tr>";
		
				}
				?>
				</table>

				<form method='post' action='index.php'><!-- bouton pour quitter la page, qui vous redirigera vers la page d'acceuil (index.php) -->
					<input type='submit' value='Quitter'>
				</form>
			</div>
		</div>
	</body>

</html>
