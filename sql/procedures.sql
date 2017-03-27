SET SERVEROUTPUT ON;

--------------------------------------------------------------------------------------------------------------
-- Convertir un id_joueur en pseudo de joueur
--------------------------------------------------------------------------------------------------------------
create or replace function id_joueur_en_pseudo(
	pId_joueur in Joueur.id_joueur%TYPE) 
  return varchar2 AS 
  
    vPseudo Joueur.pseudo%type;
	
BEGIN

  select pseudo into vPseudo from Joueur where id_joueur = pid_joueur;
  return vPseudo;
  COMMIT;

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_joueur || ' n''est pas un identifiant de joueur.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;
END;
/


-- test
begin 
  dbms_output.put_line(id_joueur_en_pseudo(4));
  COMMIT;
end ;
/



--------------------------------------------------------------------------------------------------------------
-- inscription (adresse mail check + identifiant unique)
--------------------------------------------------------------------------------------------------------------
create or replace procedure inscription(
    pPseudo in Joueur.pseudo%TYPE,
    pMail in Joueur.mail%TYPE,
    pMdp in Joueur.mdp%TYPE,
    retour out number) AS

  e_mail_un EXCEPTION;
  pragma exception_init (e_mail_un, -0001);
  e_mail_ck EXCEPTION;
  pragma exception_init (e_mail_ck, -2290);
  
BEGIN
  insert into Joueur(id_joueur, pseudo, mail, mdp) values(seq_joueur.nextval, pPseudo, pMail, pMdp);
  COMMIT;
  dbms_output.put_line('Inscription réussie.');
  retour := 0;
  
EXCEPTION
  when e_mail_un then
    dbms_output.put_line('L''adresse mail "' || pMail || '" est déjà utilisée, veulliez en choisir une autre.');
    retour := 1;
  when e_mail_ck then
    dbms_output.put_line('L''adresse mail "' || pMail || '" est invalide, veuillez la corriger.');
    retour := 2;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1; 
END;
/

-- test
declare
  retour number;
begin 
  inscription('zouzou', 'abc@gmail.com', 'sid', retour);
  dbms_output.put_line(retour);
  COMMIT;
end ;
/

select * from Joueur order by 1;



--------------------------------------------------------------------------------------------------------------
-- connexion (adresse mail + mdp)
--------------------------------------------------------------------------------------------------------------
create or replace procedure connexion(
    pMail in Joueur.mail%TYPE,
    pMdp in Joueur.mdp%TYPE,
    retour out number) AS

  vNbCompte number;
  vNbMail number;
  
BEGIN
  select count(*) into vNbCompte from Joueur 
  where mail = pMail
  and mdp = pMdp;

  if vNbCompte = 1 then
    dbms_output.put_line('Connexion autorisée.');
    retour := 0;
  else
    select count(*) into vNbMail from Joueur
    where mail = pMail;
    
    if vNbMail = 1 then
      dbms_output.put_line('Connexion non autorisée : Mot de passe invalide.');
      retour := 1;
    else
      dbms_output.put_line('Connexion non autorisée : "' || pMail || '" est une adresse mail inconnue.');
      retour := 2;
    end if;
  end if;
  COMMIT;
  
EXCEPTION
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1; 
END;
/

-- test
declare
  retour number;
begin 
  connexion('abc@gmail.com', 'sid', retour);
  dbms_output.put_line(retour);
  COMMIT;
end ;
/



--------------------------------------------------------------------------------------------------------------
-- Connaître si les deux cartes retournées sont paires
--------------------------------------------------------------------------------------------------------------
create or replace function carte_paire(
	pid_carte in Carte.id_carte%TYPE,
	pid_carte2 in Carte.id_carte%TYPE)
	RETURN NUMBER AS
	
	vid_image number;
	vid_image2 number;
	
BEGIN
	select id_image into vid_image from Carte
	where id_carte = pid_carte;
	
	select id_image into vid_image2 from Carte
	where id_carte = pid_carte2;
	
	if vid_image = vid_image2 then
		RETURN 1;
	else 
		RETURN 0;
  end if;
  COMMIT;
  
EXCEPTION
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    RETURN NULL; 
END;
/

-- test
begin 
  dbms_output.put_line(carte_paire(1,2));
  COMMIT;
end ;
/
--------------------------------------------------------------------------------------------------------------
-- Donne le résultat d'une partie
--------------------------------------------------------------------------------------------------------------
create or replace function partie_resultat(
	pid_partie in Partie.id_partie%TYPE) 
  return varchar2 AS
  
  vid_niveau Niveau.id_niveau%type;
  vid_joueur Joueur.id_joueur%type;
  vid_joueur2 Joueur.id_joueur%type;
  compteur number := 0;
  compteur2 number := 0;
  nb_paire number;
  
BEGIN
  -- recupération des informations
  select id_niveau, id_joueur, id_joueur2 into vid_niveau, vid_joueur, vid_joueur2 from Partie where id_partie = pid_partie;

  -- Comptage des paires pour le joueur 1
  for cCoup in (select * from Coup where id_partie = pid_partie and id_joueur = vid_joueur) loop
    if (carte_paire(cCoup.carte1, cCoup.carte2) = 1) then -- si c'est une paire
      compteur := compteur + 1;
    end if;
  end loop;
  
  -- si c'est une partie solo
  if (vid_joueur2 is null) then
    select ((nb_colonne*nb_ligne)/2) into nb_paire from Niveau where id_niveau = vid_niveau; -- calcule du nombre de paire pour gagner
    if (compteur = nb_paire) then
      return id_joueur_en_pseudo(vid_joueur); -- affichage du pseudo si gagné
    else 
      return 'Perdue';
    end if;
  -- si c'est une partue multi
  else 
    -- Comptage des paires pour le joueur 2
    for cCoup2 in (select carte1, carte2 from Coup where id_partie = pid_partie and id_joueur = vid_joueur2) loop
     if (carte_paire(cCoup2.carte1, cCoup2.carte2) = 1) then -- si c'est une paire
       compteur2 := compteur2 + 1;
      end if;
    end loop;
    if (compteur = compteur2) then 
      return 'Egalité';
    elsif (compteur > compteur2) then
      return id_joueur_en_pseudo(vid_joueur);
    else 
     return id_joueur_en_pseudo(vid_joueur2);
    end if;
  end if;
  COMMIT;
  
EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pid_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;
  
END;
/



--------------------------------------------------------------------------------------------------------------
-- afficherNiveaux
--------------------------------------------------------------------------------------------------------------
create or replace function niveau_joueur(
    pId_joueur in Joueur.id_joueur%type)
    return number AS

  vXp Joueur.xp%type;
  vNiveau Niveau.id_niveau%type;
  
BEGIN
  select xp into vXp
  from joueur
  where id_joueur = pId_joueur;
  
  select max(id_niveau) into vNiveau
  from niveau
  where xp_requis <= vXp;
  
  dbms_output.put_line('Le joueur ' || pId_joueur || ' peut jouer jusqu''au niveau ' || vNiveau || '.');
  return vNiveau;
  COMMIT;
  
EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_joueur || ' n''est pas un identifiant de joueur.');
    return -1;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return -1; 
END;
/

-- test
begin 
  dbms_output.put_line(niveauJoueur(2));
end ;
/



--------------------------------------------------------------------------------------------------------------
-- creationPartie pour 1 joueur
--------------------------------------------------------------------------------------------------------------
create or replace procedure creation_partie_solo(
    pId_niveau in Niveau.id_niveau%TYPE,
    pId_joueur in Joueur.id_joueur%TYPE,
    rId_partie out Partie.id_partie%TYPE) AS -- rId_partie : objet retourné à la fin de la partie

  vCollection Collection.id_collection%TYPE;
  nbCarte number := 0;
  vMinId_image Image.id_image%TYPE;
  vNb_ligne Niveau.nb_ligne%TYPE;
  vNb_colonne Niveau.nb_colonne%TYPE;
  type typ_tab is varray(100) of number; -- déclaration d'un type 'tableau' de nombres aléatoires
  tabId_image typ_tab; -- déclaration du tableau d'image piochées aléatoirement
  tab_emplacement typ_tab; -- déclaration du tableau des emplacements aléatoires
  tab_carte typ_tab; -- déclaration du tableau de carte <=> plateau de jeu
  ligne number := 0;
  colonne number := 0;
  i number := 1; -- rang/place courante dans le tableau (place qui correspondra à une carte par la suite)


BEGIN
  select seq_partie.nextval into rId_partie from dual; -- insère dans la variable rId_partie la valeur de l'Id de la partie qu'on veut créer
  insert into Partie(id_partie, id_niveau, id_joueur) values(rId_partie, pId_niveau, pId_joueur);
  -- après l'insert dans la table Partie, le trigger verification_defaites va être lancé tout seul

  -- select pour avoir les nombres de lignes et les nombres de colonnes
  select nb_ligne, nb_colonne into vNb_ligne, vNb_colonne from Niveau where id_niveau = pId_niveau;

  -- séléction de la collection en fonction du niveau
  select id_collection into vCollection from Niveau
  where id_niveau = pId_niveau;

  -- sélection de la première image de la collection
  select min(id_image) into vMinId_image
  from Image where id_collection = vCollection;

  -- stocker dans un tableau des nombres aléatoires en évitant les doublants
  -- ces nombres seront piochés parmis les 'id_image' de la bonne collection
  select distinct trunc(dbms_random.value(vMinId_image,(vMinId_image+(vNb_ligne*vNb_colonne*0.5)))+1) BULK COLLECT into tabId_image
  -- on multiplie par 0.5 pour avoir que la moitié des cartes (50 cartes <=> 25 paires)
  from dual
  connect by level <= 500
  order by dbms_random.value;

  -- on doit placer aléatoirement les cartes sur le plateau de joueur
  select distinct trunc(dbms_random.value(1,vNb_ligne*vNb_colonne+1)) BULK COLLECT into tab_emplacement
  from dual
  connect by level <= 500
  order by dbms_random.value;

  for lecture in 1..2 loop -- pour lire 2 fois le tableau tabId_image afin de mettre les paires dans les emplacements
    for image in tabId_image.first..tabId_image.last loop
      tab_carte(tab_emplacement(i)) := tabId_image(image); -- dans la table carte à un emplacement aléatoire on place l'image
      i := i + 1; -- on passe à l'emplacement aléatoire suivant
    End loop;
  End loop;

  i := 1; -- réinitialisation de i car il a été utilisé plus tôt
  -- boucle for pour créer les tuples de la table Carte
  for ligne in 1..vNb_ligne loop
    for colonne in 1..vNb_colonne loop
      insert into Carte values (seq_carte.nextval, vNb_ligne, vNb_colonne, tab_carte(i), rId_partie); -- stocker la variable de retour à la place de mettre sql_partie.currval
      i := i + 1;
    End loop;
  End loop;
			
  COMMIT;
			
EXCEPTION -- à compléter
  --when todo
  when others then
  dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );


END;
/

--------------------------------------------------------------------------------------------------------------
-- creationPartie pour 2 joueurs
--------------------------------------------------------------------------------------------------------------
create or replace procedure creation_partie_solo(
    pId_niveau in Niveau.id_niveau%TYPE,
    pId_joueur in Joueur.id_joueur%TYPE,
    pId_joueur2 in Joueur.id_joueur%TYPE,
    rId_partie out Partie.id_partie%TYPE) AS -- rId_partie : objet retourné à la fin de la partie

  vCollection Collection.id_collection%TYPE;
  nbCarte number := 0;
  vMinId_image Image.id_image%TYPE;
  vNb_ligne Niveau.nb_ligne%TYPE;
  vNb_colonne Niveau.nb_colonne%TYPE;
  type typ_tab is varray(100) of number; -- déclaration d'un type 'tableau' de nombres aléatoires
  tabId_image typ_tab; -- déclaration du tableau d'image piochées aléatoirement
  tab_emplacement typ_tab; -- déclaration du tableau des emplacements aléatoires
  tab_carte typ_tab; -- déclaration du tableau de carte <=> plateau de jeu
  ligne number := 0;
  colonne number := 0;
  i number := 1; -- rang/place courante dans le tableau (place qui correspondra à une carte par la suite)


BEGIN
  select seq_partie.nextval into rId_partie from dual; -- insère dans la variable rId_partie la valeur de l'Id de la partie qu'on veut créer
  insert into Partie(id_partie, id_niveau, id_joueur,id_joueur2) values(rId_partie, pId_niveau, pId_joueur,pId_joueur2);
  -- après l'insert dans la table Partie, le trigger verification_defaites va être lancé tout seul

  -- select pour avoir les nombres de lignes et les nombres de colonnes
  select nb_ligne, nb_colonne into vNb_ligne, vNb_colonne from Niveau where id_niveau = pId_niveau;

  -- séléction de la collection en fonction du niveau
  select id_collection into vCollection from Niveau
  where id_niveau = pId_niveau;

  -- sélection de la première image de la collection
  select min(id_image) into vMinId_image
  from Image where id_collection = vCollection;

  -- stocker dans un tableau des nombres aléatoires en évitant les doublants
  -- ces nombres seront piochés parmis les 'id_image' de la bonne collection
  select distinct trunc(dbms_random.value(vMinId_image,(vMinId_image+(vNb_ligne*vNb_colonne*0.5)))+1) BULK COLLECT into tabId_image
  -- on multiplie par 0.5 pour avoir que la moitié des cartes (50 cartes <=> 25 paires)
  from dual
  connect by level <= 500
  order by dbms_random.value;

  -- on doit placer aléatoirement les cartes sur le plateau de joueur
  select distinct trunc(dbms_random.value(1,vNb_ligne*vNb_colonne+1)) BULK COLLECT into tab_emplacement
  from dual
  connect by level <= 500
  order by dbms_random.value;

  for lecture in 1..2 loop -- pour lire 2 fois le tableau tabId_image afin de mettre les paires dans les emplacements
    for image in tabId_image.first..tabId_image.last loop
      tab_carte(tab_emplacement(i)) := tabId_image(image); -- dans la table carte à un emplacement aléatoire on place l'image
      i := i + 1; -- on passe à l'emplacement aléatoire suivant
    End loop;
  End loop;

  i := 1; -- réinitialisation de i car il a été utilisé plus tôt
  -- boucle for pour créer les tuples de la table Carte
  for ligne in 1..vNb_ligne loop
    for colonne in 1..vNb_colonne loop
      insert into Carte values (seq_carte.nextval, vNb_ligne, vNb_colonne, tab_carte(i), rId_partie); -- stocker la variable de retour à la place de mettre sql_partie.currval
      i := i + 1;
    End loop;
  End loop;
  COMMIT;

EXCEPTION -- à compléter
  --when todo
  when others then
  dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );

END;
/

--------------------------------------------------------------------------------------------------------------
-- verification_defaites
--------------------------------------------------------------------------------------------------------------

create or replace function verification_defaites(
    pId_joueur in Joueur.id_joueur%type)
    return number as
    
  compteur number := 0;

BEGIN
  for cPartie in(
      select p.id_partie 
      from partie p, coup c
      where p.id_partie = c.id_partie 
      and c.id_joueur = pId_joueur
      and heure > current_timestamp - interval '1' HOUR) loop
    if ((partie_resultat(cPartie.id_partie) <>  id_joueur_en_pseudo(pId_joueur)) or (partie_resultat(cPartie.id_partie) <>  'Egalité')) then
      compteur := compteur + 1;
    end if;
  end loop;
  
  if compteur >= 5 then 
    RAISE_APPLICATION_ERROR(-20001, 'Le joueur ' || id_joueur_en_pseudo(pId_joueur) || ' a perdu 5 partie dans la dernière heure');
  end if;
  
  return 0;
  
  COMMIT;
  
EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pid_joueur || ' n''est pas un identifiant de joueur.');
    return -1;
END;
/

-- test
begin 
  dbms_output.put_line(verification_defaites(1)); -- rajouter des valeurs dans les tables
end ;
/



--------------------------------------------------------------------------------------------------------------
-- Ajouter un coup 
--------------------------------------------------------------------------------------------------------------
create or replace procedure insert_coup(
    pId_partie in partie.id_partie%type,
    pId_joueur in Joueur.id_joueur%type,
    pCarte1 in Carte.id_carte%type,
    pCarte2 in Carte.id_carte%type,
    retour out number) AS
  
BEGIN

  INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, pId_partie, pId_joueur,  pCarte1, pCarte2);
  retour := 1;

  COMMIT;

EXCEPTION
  -- todo
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1; 
END;
/



--------------------------------------------------------------------------------------------------------------
-- Fonction qui retourne la durée d'une partie pour un id_partie donné
--------------------------------------------------------------------------------------------------------------
create or replace function duree_partie(
    pId_partie in Partie.id_partie%type)
    return INTERVAL DAY TO SECOND as

  vDuree INTERVAL DAY TO SECOND;
  
BEGIN

  select max(heure) - min(heure) into vDuree
  from coup where id_partie = pId_partie;
  
  return vDuree;
	
  COMMIT;

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
END;
/

-- test
begin 
  dbms_output.put_line(duree_partie(1)); -- rajouter des valeurs dans les tables
end ;
/



--------------------------------------------------------------------------------------------------------------
-- Fonction qui retourne le nombre de coups d'une partie pour un id_partie donné
--------------------------------------------------------------------------------------------------------------
create or replace function nb_coup_partie(
    pId_partie in Partie.id_partie%type)
    return number as

  vNb_Coup number;
  
BEGIN

  select count(id_coup) into vNb_Coup
  from coup 
  where id_partie = pId_partie;
  
  return vNb_Coup;
  COMMIT;
			
EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
END;
  
-- test
begin 
  dbms_output.put_line(nb_coup_partie(1)); -- rajouter des valeurs dans les tables
end ;
/


--------------------------------------------------------------------------------------------------------------
-- Fonction qui retourne la date et l'heure d'une partie pour un id_partie donné
--------------------------------------------------------------------------------------------------------------
create or replace function heure_partie(
    pId_partie in Partie.id_partie%type)
    return Coup.heure%TYPE as

  vHeure Coup.heure%TYPE;
  
BEGIN

  select max(heure) into vHeure
  from coup 
  where id_partie = pId_partie;
  
  return vHeure;
  COMMIT;
			
EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
END;
  
-- test
begin 
  dbms_output.put_line(heure_partie(1)); -- rajouter des valeurs dans les tables
  COMMIT;
end ;
/
