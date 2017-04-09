<?php
require("db/connect.php");

/* Insertion d'un coup dans la base de donnée grâce à la fonction insert_coup de la BD qui prend en argument l'identifiant de la partie l'identifiant du joueur qui vient de jouer le coup, ainsi que l'identifiant des deux cartes qu'il a joué. Les argument sont récupérés grâce à la fonction ajax ajoutcoup et envoyé via la méthode GET  */

$procedure = oci_parse($dbConn, 'call "21602883".insert_coup(:p_idpartie, :p_idjoueur, :p_carte1, :p_carte2,:retour)');
oci_bind_by_name($procedure, ':p_idpartie', $_GET['idpartie'],5); // $_GET['idpartie']: récupère l'identifiant de la partie 
oci_bind_by_name($procedure, ':p_idjoueur', $_GET['idjoueur'],10); // $_GET['idjoueur']: récupère l'identifiant du joueur 
oci_bind_by_name($procedure, ':p_carte1', $_GET['carte1'], 10); // $_GET['carte1']: récupère l'identifiant de la carte 1 
oci_bind_by_name($procedure, ':p_carte2', $_GET['carte2'], 10); // $_GET['carte2']: récupère l'identifiant de la carte 2
oci_bind_by_name($procedure, ':retour', $r, 50); 
oci_execute($procedure);

?>

