<html>
  <head>
    <title> Jeu: Memory </title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src = "index.js"></script>

    <link rel="stylesheet" href="bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="index.css">
  </head>

  <body>
    <div id = "base">
      <h1 class = "centrer"> Memory </h1>
      <img src = "memory.jpg" width = 400>

      <h3><audio  src="dll.mp3" controls loop</audio> </h3>
        <!-- code du menu -->
        <?php include("menus.php"); ?>
        <table>
          <caption>TOP 5</caption>

          <thead> <!-- En-tête du tableau -->
            <tr>
              <th>Nom</th>
              <th>Âge</th>
              <th>XP</th>
            </tr>
        </thead>

        <tbody> <!-- Corps du tableau -->
          <tr>
           <td>Sofian</td>
           <td>21</td>
           <td>1200</td>
         </tr>
         <tr>
           <td>Camille</td>
           <td>20</td>
           <td>100</td>
         </tr>
         <tr>
           <td>Claire</td>
           <td>4</td>
           <td>60</td>
         </tr>
         <tr>
           <td>Céline</td>
           <td>90</td>
           <td>50</td>
         </tr>
         <tr>
           <td>Nos</td>
           <td>30</td>
           <td>40</td>
         </tr>
       </tbody>
     </table>
   </div>
</body>
