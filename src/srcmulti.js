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

function jouer(a,src,nbPaire,idpartie,idjoueur1,idjoueur2,idcarte) {
	idpart=idpartie;
	idj1=idjoueur1;
	idj2=idjoueur2;
	nbPaireMax=nbPaire;
	// recup pour a + le numero de ligne et colonne où il a clique
	// alle sur la bd et cherche quelle est la source dans cette ligne et colonne
	nbCarte ++;
	if(nbCarte == 1 ){
		image1 = document.getElementById(a.id);
		image1.src = src;
		id_carte1=idcarte;
	}
	else if ( (nbCarte == 2) && (document.getElementById(a.id)!= image1)){
		image2= document.getElementById(a.id);
		image2.src = src;
		id_carte2=idcarte;
		window.setTimeout("deuxieme_coup()",1000);			
	}
	else{
		nbCarte=nbCarte-1;
	}
}

function deuxieme_coup(){
	if( image1.src == image2.src){
		
		image1.onclick="none";
		image2.onclick="none";
		image1.src = "PaireTrouvee.png";
		image2.src = "PaireTrouvee.png";
		image1.alt = "Paire Trouvée";
		image2.alt = "Paire Trouvée";
		if (Joueur == Joueur1){
			nbPaireJoueur1 += 1; 
			ajoutcoup(idpart,idj1,id_carte1,id_carte2);
		}
		else{
		nbPaireJoueur2 += 1; 
			ajoutcoup(idpart,idj2,id_carte1,id_carte2);
		}
		finParti(nbPaireJoueur1,nbPaireJoueur2,idpart);
			
	}
	else{
		image1.src = "face_cache.jpg";
		image2.src = "face_cache.jpg";
		if (Joueur == Joueur1){
			ajoutcoup(idpart,idj1,id_carte1,id_carte2); 
			Joueur = 0;
			alert("C'est au joueur2 de jouer");
		}else {
			ajoutcoup(idpart,idj2,id_carte1,id_carte2);
			Joueur = 1;
			alert("C'est au joueur1 de jouer");
		}
	}
		
	nbCoups ++;
	nbCarte=0;
}

function finParti(nbPaireJ1, nbPaireJ2,idpart){
	var nbPaireJouee;
	nbPaireJouee = nbPaireJ1 + nbPaireJ2; 
	if (nbPaireJouee == nbPaireMax) {
		termineparti(idpart);
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
	
function ajoutcoup(idp,idj,ic1,ic2) {
	$.ajax({
		url: 'ajoutcoup.php',
		type: 'GET',
		data : 'idpartie=' + encodeURIComponent(idp) + '&idjoueur='+ encodeURIComponent(idj)  + '&carte1='+ encodeURIComponent(ic1)  + '&carte2='+ encodeURIComponent(ic2),
		dataType : 'text'
	});
}

function termineparti(idp) {
	$.ajax({
		url: 'termiparti.php',
		type: 'GET',
		data : 'idpartie=' + encodeURIComponent(idp),
		dataType : 'text'
	});
}
