	var nbCarte=0;
	var image1;
	var image2;	
	var nbCoups=0;
	var termine=0;
	var nbPaireMax=0 ;
	var nbPaire=0;
	
	
	function jouer(a,src,nbPairesM,idpartie,idjoueur1,idcarte) {
		idpart=idpartie;
		idj1=idjoueur1;
		nbPaireMax=nbPairesM;
		
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
			nbPaire+= 1; 
			finParti(nbPaire,idpart);

		}
		else{
			image1.src = "face_cache.jpg";
			image2.src = "face_cache.jpg";
			
		}
		nbCarte=0;
		nbCoups ++; 
		ajoutcoup(idpart,idj1,id_carte1,id_carte2);
	}

	function finParti(nbPaireJouee,idpart){
		if (nbPaireJouee == nbPaireMax) {
				termineparti(idpart);
				alert("La partie est fini, vous avez gagné");
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
