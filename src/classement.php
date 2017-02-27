<?php

include("db/connect.php");

$strSQL = "select pseudo from Joueur";

$stmt = oci_parse($dbConn,$strSQL);
if ( ! oci_execute($stmt) ){
$err = oci_error($stmt);
trigger_error('Query failed: ' . $err['message'], E_USER_ERROR);
};


?>
<!DOCTYPE html>
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

        <!-- code du menu -->
        <?php include("menu.php"); ?>
	         <h1>Liste des pseudos</h1>
		       <table>
		             <tr>
		                 <th>Pseudo</th>
		             </tr>
                 <?php
                 while(oci_fetch($stmt)){
                   $rsltpseudo = oci_result($stmt, 1);
                   print "<tr><td>".$rsltpseudo."</td></tr>";
                 }
                  ?>
            </table>
      </div>
    </body>
</html>
