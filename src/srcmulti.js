var nbCarte=0;
var carte1;
var carte2;	
var nbCoups=0; 
var Joueur1 = 1; 
var Joueur2 = 0;
var Joueur = 1;
var nbPaireJoueur1 = 0; 
var nbPaireJoueur2 = 0;
var nbPaireMax=0 ;
var idj1;
var idj2; 
var idJoueurCourant;	

/*Entré : carte : récupère la carte sur laquelle l'utilisateur vient de cliquer
	  src : Url de l'image que contient la carte choisie
	  nbPaireM : le nombre de paire présente dans la partie
	  idPartie : l'identifiant de la partie en cours
	  idJoueur1 : l'identifiant du joueur qui joue la partie
	  idJoueur2 : l'identifiant du joueur qui joue la partie
	  idCarte: l'identifiant de la carte
	  
	  Corps : Affecte à joueurCourant l'identifiant du joueur 
	  Stocke dans carte1 la première carte qu'à choisi l'utilisateur et dévoile son image
	  Stocke dans carte2 la deuxième carte sur laquelle l'utilisateur a cliqué si elle est différente de la première et dévoile son image
	  Une fois qu'on a les deux cartes, on appelle la fonction paire*/



function jouer(carte,src,nbPaireM,idpartie,idJoueur1,idJoueur2,idCarte) {
	idpart=idpartie;
	idj1=idJoueur1;
	idj2=idJoueur2;
	nbPaireMax=nbPaireM;
	nbCarte ++;
	attributionJoueurCourant(idj1,idj2); 
	if(nbCarte == 1 ){
		carte1 = document.getElementById(carte.id);
		/* Assignation de l'image à l'objet carte --> retourne la carte (visualisation de l'image) */
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
	ajoutcoup(idpart,idJoueurCourant,id_carte1,id_carte2);
	if( carte1.src == carte2.src){
		// Les cartes choisis forment une paire --> on interdit le clique dessus et on affecte l'image paireTrouve et on met à jour du texte alternatif de l'image
		carte1.onclick="none";
		carte2.onclick="none";
		carte1.src = "PaireTrouvee.png";
		carte2.src = "PaireTrouvee.png";
		carte1.alt = "Paire Trouvée";
		carte2.alt = "Paire Trouvée";
		// On met à jour le score
		if (Joueur == Joueur1){
			nbPaireJoueur1 += 1; 
		}
		else{
			nbPaireJoueur2 += 1;
		}
		// On regarde s'il reste des paires à trouver
		finParti(nbPaireJoueur1,nbPaireJoueur2,idpart);		
	}
	else{
		// Les cartes choisis ne forment pas une paire -->  on les retourne
		carte1.src = "face_cache.jpg";
		carte2.src = "face_cache.jpg";
		carte1.alt = "face_cache";
		carte2.alt = "face_cache";
		if (Joueur == Joueur1){
			Joueur = 0;
			alert("C'est au joueur2 de jouer");
		}else {
			Joueur = 1;
			alert("C'est au joueur1 de jouer");
		}
	}
	nbCarte=0;
}

/* Entrée : idj1 : identifiant du joueur 1
	    idj2 : identifiant du joueur 2
   Corps  : détermine quelle joueur est entrain de jouer et affecte son identifant à la variable idJoueurCourant*/
function attributionJoueurCourant(idj1,idj2) {
	if (Joueur == Joueur1){
		idJoueurCourant = idj1;
	}else{
		idJoueurCourant = idj2;
	}
}

/* Entrée : nbPaireJ1 : nombre de paire trouvé par le joueur 1
	    nbPaireJ2 : nombre de paire trouvé par le joueur 2
	    idPartie : identifiant de la partie en cours
   Corps  : Regarde si toutes les paires ont été joué
	    Si oui affiche un message contenant le score de la partie et le joueur qui a gagné*/
function finParti(nbPaireJ1, nbPaireJ2,idPartie){
	if ((nbPaireJ1 + nbPaireJ2) == nbPaireMax) {
		termineparti(idPartie);
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

/*Entrée : 
	  idp: Identifiant de la partie en cours
	  idj : Identifiant du joueur
	  idc1 : Identifiant de la carte 1
	  idc2 : Identifiant de la carte 2
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
