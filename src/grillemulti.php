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
$niv1 =  oci_parse($dbConn,'begin :r := niveau_Joueur(:id); end;'); // obtenir le niveau du joueur
		oci_bind_by_name($niv1, ':id', $_SESSION['id'],10);
		oci_bind_by_name($niv1, ':r', $nivJ1,10);
		oci_execute($niv1);
$niv2 =  oci_parse($dbConn,'begin :r := niveau_joueur(:id); end;'); // obtenir le niveau du joueur
		oci_bind_by_name($niv2, ':id', $_SESSION['id2'],10);
		oci_bind_by_name($niv2, ':r', $nivJ2,10);
		oci_execute($niv2);

if ($nivJ1 > $nivJ2) { 
	$nivJ = $nivJ2 ;
}else {
	$nivJ = $nivJ1 ;;
}
?>

<html>
  <head>
    <title> Jeu: Memory </title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src = "index.js"></script>

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
      </br>
      </br>
    <table>
    
    <form method="post" action="multigame.php">
<?php

		$g=0;

//Creation d'un formulaire qui affiche les niveaux via des boutons submit : grille 5*10
		for ($ii=0; $ii<5 ; $ii++) { 
			echo"<tr>";
			for ($jj=0; $jj<10; $jj++) { 
				$g++;
				if ($g <= $nivJ) { 
					echo"<td> <input type=\"submit\" name =\"niveau\" value ='$g' id=$g /> </td>";
				}else {
					echo"<td>   $g  </td>";
				}

			} 
			echo"</tr>";
		
		} 
		?>
    </form>
    
    </table>
<?php
echo $_SESSION['id'];
echo $_SESSION['id2'];
?>
  </body>
</html>
