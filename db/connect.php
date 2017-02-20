<?php 
 
$dbHost = "ntelline.cict.fr";
$dbHostPort="1522";
$dbServiceName = "etupre";
$usr = "YOUR_ACCOUNT";
$pswd = "YOUR_PASSWORD";
$dbConnStr = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)
        (HOST=".$dbHost.")(PORT=".$dbHostPort."))
        (CONNECT_DATA=(SERVICE_NAME=".$dbServiceName.")))";
 
if(!$dbConn = oci_connect($usr,$pswd,$dbConnStr)){
  $err = oci_error();
  trigger_error('Could not establish a connection: ' . $err['message'], E_USER_ERROR);
}

?>
