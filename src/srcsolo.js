//Déclaration des variables globales
var nbCarte=0;
var carte1;
var carte2;	
var nbCoups=0;
var nbPaireMax=0 ;
var nbPaire=0;
var idpart;
var idj1;
var tempsRestant;	
var chrono;
var finTemps;
var debutP;
var chronoFin = 0;

/*Entré : carte : récupère la carte sur laquelle l'utilisateur vient de cliquer
	  src : Url de l'image que contient la carte choisie
	  nbPaireM : le nombre de paire présente dans la partie
	  idPartie : l'identifiant de la partie en cours
	  idJoueur : l'identifiant du joueur qui joue la partie
	  idCarte : l'identifiant de la carte
  Corps : Affecte à joueurCourant l'identifiant du joueur 
	  Stocke dans carte1 la première carte qu'à choisi l'utilisateur et dévoile son image
	  Stocke dans carte2 la deuxième carte sur laquelle l'utilisateur a cliqué si elle est différente de la première et dévoile son image
	  Une fois qu'on a les deux cartes, on appelle la fonction paire
*/	
function jouer(carte,src,nbPairesM,idPartie,idJoueur,idCarte) {
	idpart=idPartie;
	idj1=idJoueur;
	nbPaireMax=nbPairesM; 
	if (nbCoups ==0) {
		//création de la variable finTemps permettant d'avoir le temps de fin de partie (temps actuel + 1min)
		debutP = new Date().getTime();		
		finTemps = debutP + 1*60*1000;
	}
	//Mise en place d'un chronomètre d'une minutes qui s'actualise toutes les secondes
	chrono = setInterval(function() {
		var now;
		var minutes;
		var secondes;
		//la variable now prend le temps acutel
		now = new Date().getTime();
		//Calcul du temps qu'il nous reste à jouer
		tempsRestant = finTemps - now;
		//Cacul des minutes restantes à jouer
		minutes = Math.floor((tempsRestant % (1000 * 60 * 60)) / (1000 * 60));
		//Calcul des secondes restants à jouer
		secondes = Math.floor((tempsRestant % (1000 * 60)) / 1000);
		// Affiche du chronomètre sous la forme XXmXXs
 		document.getElementById("chrono").innerHTML = minutes + "m " + secondes + "s ";
		// Si le temps de jeu de la partie est écoulé on affiche un message prévenant le joueur que la partie est terminé et on lance la fonction finParti
  		if (tempsRestant <= 0) {
    			clearInterval(chrono);
			chronoFin = 1;
			finParti(nbPaire,idPartie,chronoFin)
    			document.getElementById("chrono").innerHTML = "Le chronomètre est écoulé vous avez perdu la partie";
  		}
	},1000);
	nbCarte ++;
	if(nbCarte == 1 ){
		carte1 = document.getElementById(carte.id);
		//Assignation de l'image à l'objet carte --> retourne la carte (visualisation de l'image)
		carte1.src = src;
		id_carte1=idCarte;
	}
	else if ( (nbCarte == 2) && (document.getElementById(carte.id)!= carte1)){
		carte2= document.getElementById(carte.id);
		//Assignation de l'image à l'objet carte --> retourne la carte (visualisation de l'image)
		carte2.src = src;
		id_carte2=idCarte;
		// fonction window.setTimeout permet d'attendre un certain temps avant de déclancher la fonction paire --> permet au joueur de visualiser les deux cartes
		window.setTimeout("paire()",1000);
	}
	else{
		// Si l'utilisateur a cliqué sur la même carte, on rétablie le nombre de carte a 1
		nbCarte=nbCarte-1;
	}
}

	
// Permet de déterminer si la paire de carte choisi par l'utilisateur forme une paire ou non
function paire(){
	nbCoups ++; 
	ajoutcoup(idpart,idj1,id_carte1,id_carte2);
	if( carte1.src == carte2.src){
	// Les cartes choisis forment une paire --> on interdit le clique dessus et on affecte l'image paireTrouve et on met à jour du texte alternatif de l'image
		carte1.onclick="none";
		carte2.onclick="none";
		carte1.src = "PaireTrouvee.png";
		carte2.src = "PaireTrouvee.png";
		carte1.alt = "Paire Trouvée";
		carte2.alt = "Paire Trouvée";
		nbPaire+= 1; 
		// On regarde s'il reste des paires à trouver
		finParti(nbPaire,idpart,chronoFin);
	}
	else{
		carte1.src = "face_cache.jpg";
		carte2.src = "face_cache.jpg";
		carte1.alt = "face_cache";
		carte2.alt = "face_cache";
	}
	nbCarte=0;
}

/* Entrée : nbPaireJouee : nombre de paire trouvé par le joueur
idPartie : identifiant de la partie en cours
Corps  : Regarde si toutes les paires ont été joué
Si oui affiche un message contenant le score de la partie et si joueur a gagné */
function finParti(nbPaireJouee,idPartie,chronoFini){
	if (nbPaireJouee == nbPaireMax){ 
		termineparti(idPartie);
		alert("La partie est fini, vous avez gagné");
	}
	if (chronoFini == 1){
		termineparti(idPartie);
	}
	 
}

/*Entrée : 
	  idp: Identifiant de la partie en cours
	  idj : Identifiant du joueur
	  idC1 : Identifiant de la carte 1
	  idC2 : Identifiant de la carte 2
   Corps : 
	  Envoie de l'identifiant partie, du joueur et des deux cartes jouées vers le fichier ajoutcoup.php afin d'enregistrer le coup jouer dans la base de donnée*/
function ajoutcoup(idp,idj,ic1,ic2) {
	$.ajax({
		url: 'ajoutcoup.php',
		type: 'GET',
		data : 'idpartie=' + encodeURIComponent(idp) + '&idjoueur='+ encodeURIComponent(idj)  + '&carte1='+ encodeURIComponent(ic1)  + '&carte2='+ encodeURIComponent(ic2),
		dataType : 'text'
	});
}

/*Entrée : 
	   idp : identifiant de la partie en cours
  Corps  : 
	   Envoie de l'identifiant de la partie vers le fichier terminerparti afin d'actualiser de le statut de la partie (en cours --> terminé) */
function termineparti(idp) {
	$.ajax({
		url: 'termiparti.php',
		type: 'GET',
		data : 'idpartie=' + encodeURIComponent(idp),
		dataType : 'text'
	});
}
