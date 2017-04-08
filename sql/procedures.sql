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

  e_unicite EXCEPTION;
  pragma exception_init (e_unicite, -0001);
  e_mail_ck EXCEPTION;
  pragma exception_init (e_mail_ck, -2290);

BEGIN
  insert into Joueur(id_joueur, pseudo, mail, mdp) values(seq_joueur.nextval, pPseudo, pMail, pMdp);
  retour := 0; -- authentification réussie
  COMMIT;

EXCEPTION
  when e_unicite then
    if sqlerrm like '%MAIL%' then
      DBMS_OUTPUT.PUT_LINE('L''adresse mail "' || pMail || '" est déjà utilisée, veulliez en choisir une autre.');
      retour := 1;
    elsif sqlerrm like '%PSEUDO%' then
      DBMS_OUTPUT.PUT_LINE('Le pseudo "' || pPseudo || '" est déjà utilisé.');
      retour := 2;
    else
      dbms_output.put_line('Erreur de clé étrangère inconnue : '|| sqlerrm); 
      retour := 3;
    end if;
    ROLLBACK;
  when e_mail_ck then
    dbms_output.put_line('L''adresse mail "' || pMail || '" est invalide, veuillez la corriger.');
    retour := 4;
    ROLLBACK;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1;
    ROLLBACK;
END;
/

-- test
declare
  retour number;
begin
  inscription('zouzouS', 'dvoila@gmail.com', 'mdr', retour);
  dbms_output.put_line(retour);
end ;
/

-- test
declare
  retour number;
begin
  inscription('zouzou', 'abc@gmail.com', 'sid', retour);
  dbms_output.put_line(retour);
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
    retour := 0; -- connexion autorisée
  else
    select count(*) into vNbMail from Joueur
    where mail = pMail;

    if vNbMail = 1 then
      retour := 1; -- connexion non autorisée car mot de passe invalide
    else
      retour := 2; -- connexion non autorisée car adresse mail inconnue
    end if;
  end if;

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
end ;
/

--------------------------------------------------------------------------------------------------------------
-- Savoir si deux cartes sont paires ou non
--------------------------------------------------------------------------------------------------------------
create or replace function carte_paire(
  pid_carte in Carte.id_carte%TYPE,
  pid_carte2 in Carte.id_carte%TYPE)
  RETURN NUMBER AS

  vid_image number;
  vid_image2 number;

  flag number := 0; --permet de savoir quelle carte a levée l'exception

BEGIN
  select id_image into vid_image from Carte -- sélectionne l'image correspondant à la carte 1 qu'on retourne
  where id_carte = pid_carte;

  flag := 1; -- permet de savoir si l'exception est levée à cause de la carte2

  select id_image into vid_image2 from Carte -- sélectionne l'image correspondant à la carte 2 qu'on retourne
  where id_carte = pid_carte2;

  if vid_image = vid_image2 then
    RETURN 1; -- paire de cartes
  else
    RETURN 0; -- les cartes ne sont pas paires
  end if;

EXCEPTION
  when NO_DATA_FOUND then
    if flag = 0 then
      dbms_output.put_line('La carte ' || pid_carte || ' n''existe pas.');
    elsif flag = 1 then
      dbms_output.put_line('La carte ' || pid_carte2 || ' n''existe pas.');
    else
      dbms_output.put_line('Erreur inconnue de données introuvables');
    end if;
    RETURN NULL;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    RETURN NULL;
END;
/

-- test
begin
  dbms_output.put_line(carte_paire(3,99));
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

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pid_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;

END;
/


-- test
begin
  dbms_output.put_line(partie_resultat(1));
end ;
/


--------------------------------------------------------------------------------------------------------------
-- fonction qui affiche les niveaux auxquels le joueur a accès
--------------------------------------------------------------------------------------------------------------
create or replace function niveau_joueur(
    pId_joueur in Joueur.id_joueur%type)
    return number AS

  vXp Joueur.xp%type;
  vNiveau Niveau.id_niveau%type;

BEGIN
  select xp into vXp -- sélectionne xp pour le joueur
  from joueur
  where id_joueur = pId_joueur;

  select max(id_niveau) into vNiveau -- sélectionne l'id_niveau max auquel le joueur à droit suivant son xp
  from niveau
  where xp_requis <= vXp; --

  return vNiveau;

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
  dbms_output.put_line(niveau_joueur(652));
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

  type typ_tab is table of number INDEX BY BINARY_INTEGER; -- déclaration d'un type 'tableau' de nombres aléatoires
  tabId_image typ_tab; -- déclaration du tableau d'image piochées aléatoirement
  tab_carte typ_tab; -- déclaration du tableau de carte <=> plateau de jeu

  type typ_tab_index is table of BINARY_INTEGER INDEX BY BINARY_INTEGER;  -- déclaration du tableau des emplacements aléatoires
  tab_emplacement typ_tab_index;

  ligne number := 0;
  colonne number := 0;
  i pls_integer := 1; -- rang/place courante dans le tableau (place qui correspondra à une carte par la suite)

  fkInexistante exception ;
  pragma exception_init ( fkInexistante , -2291) ;

BEGIN
  select seq_partie.nextval into rId_partie from dual; -- insère dans la variable rId_partie la valeur de l'Id de la partie qu'on veut créer
  insert into Partie(id_partie, id_niveau, id_joueur) values(rId_partie, pId_niveau, pId_joueur);
  -- après l'insert dans la table Partie, le trigger verification_defaites va être lancé tout seul

  -- select pour avoir les nombres de lignes et les nombres de colonnes
  select nb_ligne, nb_colonne into vNb_ligne, vNb_colonne from Niveau where id_niveau = pId_niveau;

  -- séléction de la collection en fonction du niveau
  select id_collection into vCollection
  from Niveau
  where id_niveau = pId_niveau;

  -- sélection de la première image de la collection
  select min(id_image) into vMinId_image
  from Image
  where id_collection = vCollection;

  -- stocker dans un tableau des nombres aléatoires en évitant les doublants
  -- ces nombres seront piochés parmis les 'id_image' de la bonne collection
  select distinct trunc(dbms_random.value(vMinId_image,(vMinId_image+vNb_ligne*vNb_colonne*0.5))) BULK COLLECT into tabId_image
  -- on multiplie par 0.5 pour avoir que la moitié des cartes (50 cartes <=> 25 paires)
  from dual
  connect by level <= 500
  order by dbms_random.value;

  -- on doit placer aléatoirement les cartes sur le plateau de joueur
  select distinct trunc(dbms_random.value(1,(vNb_ligne*vNb_colonne)+1)) BULK COLLECT into tab_emplacement
  from dual
  connect by level <= 500
  order by dbms_random.value;

  i := 1;
  for lecture in 1..2 loop -- pour lire 2 fois le tableau tabId_image afin de mettre les paires dans les emplacements
    for image in tabId_image.first..tabId_image.last loop
      tab_carte(i) := tabId_image(image); -- dans la table carte à un emplacement aléatoire on place l'image
      i := i + 1; -- on passe à l'emplacement aléatoire suivant
    End loop;
  End loop;

  i := 1;
  for ligne in 1..vNb_ligne loop
    for colonne in 1..vNb_colonne loop
      -- insérer dans la table Carte les cartes que l'on vient de créer
      insert into Carte values (seq_carte.nextval, ligne, colonne, tab_carte(tab_emplacement(i)), rId_partie);
      -- stocker la variable de retour à la place de mettre sql_partie.currval
      i := i + 1 ;
    end loop;
  end loop;

  COMMIT;

EXCEPTION
  when fkInexistante then
    if sqlerrm like '%JOUEUR%' then
      DBMS_OUTPUT.PUT_LINE('L''id joueur ' || pId_joueur || ' n''existe pas.') ;
    elsif sqlerrm like '%NIVEAU%' then
      DBMS_OUTPUT.PUT_LINE('Le niveau '|| pId_niveau || ' n''existe pas. Veuilliez insérer un niveau compris entre 1 et 50.') ;
    else
      DBMS_OUTPUT.PUT_LINE('Erreur inconnue de  données non trouvées.') ;
    end if ;
    rId_partie := null;
    ROLLBACK;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    rId_partie := null;
    ROLLBACK;
END;
/

select * from partie order by 1;

--test
declare
  ret number;
begin
  creation_partie_solo(3, 2, ret);
  DBMS_OUTPUT.PUT_LINE('id_partie : ' || ret);
end;
/

--------------------------------------------------------------------------------------------------------------
-- creationPartie pour 2 joueurs
--------------------------------------------------------------------------------------------------------------
create or replace procedure creation_partie_multi(
    pId_niveau in Niveau.id_niveau%TYPE,
    pId_joueur in Joueur.id_joueur%TYPE,
    pId_joueur2 in Joueur.id_joueur%TYPE,
    rId_partie out Partie.id_partie%TYPE) AS -- rId_partie : objet retourné à la fin de la partie

  vCollection Collection.id_collection%TYPE;
  nbCarte number := 0;
  vMinId_image Image.id_image%TYPE;
  vNb_ligne Niveau.nb_ligne%TYPE;
  vNb_colonne Niveau.nb_colonne%TYPE;

  type typ_tab is table of number INDEX BY BINARY_INTEGER; -- déclaration d'un type 'tableau' de nombres aléatoires
  tabId_image typ_tab; -- déclaration du tableau d'image piochées aléatoirement
  tab_carte typ_tab; -- déclaration du tableau de carte <=> plateau de jeu

  type typ_tab_index is table of BINARY_INTEGER INDEX BY BINARY_INTEGER;  -- déclaration du tableau des emplacements aléatoires
  tab_emplacement typ_tab_index;

  ligne number := 0;
  colonne number := 0;
  i pls_integer := 1; -- rang/place courante dans le tableau (place qui correspondra à une carte par la suite)

  fkInexistante exception ;
  pragma exception_init ( fkInexistante , -2291) ;

BEGIN
  select seq_partie.nextval into rId_partie from dual; -- insère dans la variable rId_partie la valeur de l'Id de la partie qu'on veut créer
  insert into Partie(id_partie, id_niveau, id_joueur, id_joueur2) values(rId_partie, pId_niveau, pId_joueur, pId_joueur2);
  -- après l'insert dans la table Partie, le trigger verification_defaites va être lancé tout seul

  -- select pour avoir les nombres de lignes et les nombres de colonnes
  select nb_ligne, nb_colonne into vNb_ligne, vNb_colonne from Niveau where id_niveau = pId_niveau;

  -- sélection de la collection en fonction du niveau
  select id_collection into vCollection
  from Niveau
  where id_niveau = pId_niveau;

  -- sélection de la première image de la collection
  select min(id_image) into vMinId_image
  from Image
  where id_collection = vCollection;

  -- stocker dans un tableau des nombres aléatoires en évitant les doublants
  -- ces nombres seront piochés parmis les 'id_image' de la bonne collection
  select distinct trunc(dbms_random.value(vMinId_image,(vMinId_image+vNb_ligne*vNb_colonne*0.5))) BULK COLLECT into tabId_image
  -- on multiplie par 0.5 pour avoir que la moitié des cartes (50 cartes <=> 25 paires)
  from dual
  connect by level <= 500
  order by dbms_random.value;

  -- on doit placer aléatoirement les cartes sur le plateau de joueur
  select distinct trunc(dbms_random.value(1,(vNb_ligne*vNb_colonne)+1)) BULK COLLECT into tab_emplacement
  from dual
  connect by level <= 500
  order by dbms_random.value;

  i := 1;
  for lecture in 1..2 loop -- pour lire 2 fois le tableau tabId_image afin de mettre les paires dans les emplacements
    for image in tabId_image.first..tabId_image.last loop
      tab_carte(i) := tabId_image(image);
      --DBMS_OUTPUT.PUT_LINE(tab_carte(i));
      --DBMS_OUTPUT.PUT_LINE(tab_emplacement(i)); -- dans la table carte à un emplacement aléatoire on place l'image
      i := i + 1; -- on passe à l'emplacement aléatoire suivant
    End loop;
  End loop;

  i := 1;
  for ligne in 1..vNb_ligne loop
    for colonne in 1..vNb_colonne loop
      --DBMS_OUTPUT.PUT_LINE(i || ' - ' || ligne || ' - ' || colonne || ' - ' || tab_carte(tab_emplacement(i)));
      insert into Carte values (seq_carte.nextval, ligne, colonne, tab_carte(tab_emplacement(i)), rId_partie); -- stocker la variable de retour à la place de mettre sql_partie.currval
      i := i + 1 ;
    end loop;
  end loop;

  COMMIT;

EXCEPTION
  when fkInexistante then
    ROLLBACK;
    if sqlerrm like '%JOUEUR2%' then
      DBMS_OUTPUT.PUT_LINE('L''id joueur ' || pId_joueur2 || ' n''existe pas.');
    elsif sqlerrm like '%JOUEUR%' then
      DBMS_OUTPUT.PUT_LINE('L''id joueur ' || pId_joueur || ' n''existe pas.');
    elsif sqlerrm like '%NIVEAU%' then
      DBMS_OUTPUT.PUT_LINE('Le niveau '|| pId_niveau || ' n''existe pas. Veuilliez insérer un niveau compris entre 1 et 50.') ;
    else
      DBMS_OUTPUT.PUT_LINE('Erreur de clé étrangère inconnue : ' || sqlerrm);
    end if ;
    rId_partie := null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    rId_partie := null;
    ROLLBACK;
END;
/

-- test
declare
  ret number;
begin
  creation_partie_multi(50, 1, 2, ret);
  DBMS_OUTPUT.PUT_LINE('id_partie : ' || ret);
end;
/

select niveau_joueur(1) from dual;

select * from niveau;
select * from COLLECTION;
select count(*), id_collection from image group by id_collection;
select min(id_image), max(id_image) from image where ID_COLLECTION = 5;
select * from Carte order by 5;

--------------------------------------------------------------------------------------------------------------
-- Ajouter un coup
--------------------------------------------------------------------------------------------------------------
create or replace procedure insert_coup(
    pId_partie in partie.id_partie%type,
    pId_joueur in Joueur.id_joueur%type,
    pCarte1 in Carte.id_carte%type,
    pCarte2 in Carte.id_carte%type,
    retour out number) AS

  fkInexistante exception ;
  pragma exception_init (fkInexistante , -2291) ;

BEGIN
  INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, pId_partie, pId_joueur,  pCarte1, pCarte2);
  retour := 1;

  COMMIT;

EXCEPTION
  when fkInexistante then
    ROLLBACK;
    if sqlerrm like '%PARTIE%' then
      DBMS_OUTPUT.PUT_LINE('L''id de la partie ' || pId_partie || ' n''existe pas.');
    elsif sqlerrm like '%JOUEUR%' then
      DBMS_OUTPUT.PUT_LINE('L''id du joueur ' || pId_joueur || ' n''existe pas.');
    elsif sqlerrm like '%CARTE1%' then
      DBMS_OUTPUT.PUT_LINE('La carte '|| pCarte1 || ' n''existe pas.');
    elsif sqlerrm like '%CARTE2%' then
      DBMS_OUTPUT.PUT_LINE('La carte '|| pCarte2 || ' n''existe pas.');
    else
      DBMS_OUTPUT.PUT_LINE('Erreur de clé étrangère inconnue : ' || sqlerrm);
    end if ;
    retour := null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    ROLLBACK;
    retour := null;
END;
/

-- test
declare 
  retour number;
begin
  insert_coup(140,1,4, 3, retour);
  DBMS_OUTPUT.put_line(retour);
end;
/
  
select * from Carte where id_partie = 140;


--------------------------------------------------------------------------------------------------------------
-- permet de passer une partie de 'En cours' à 'Terminé'
--------------------------------------------------------------------------------------------------------------
create or replace procedure terminer_partie(
    pId_partie in Partie.id_partie%TYPE,
    retour out number) AS

  vCateg Categorie.id_categorie%type;
  vXP1 Joueur.xp%type;
  vXP2 Joueur.xp%type;
  vDiffXP number;
  vId_joueur Partie.id_joueur%type;
  vId_joueur2 Partie.id_joueur%type;
  

BEGIN
  select id_joueur, id_joueur2 into vId_joueur, vId_joueur2 from Partie where id_partie = pId_partie;
  
  update Partie set etat = 'Terminé' where id_partie = pId_partie;


  if vId_joueur2 is null then -- cas partie mono-joueur
    if partie_resultat(pId_partie) = id_joueur_en_pseudo(vId_joueur) then -- si la parie est gagnée
      -- partie_resultat : retourne le pseudo du gagnant si le joueur a gagner ou 'Perdu' sinon
      -- on compare ce résultat avec le pseudo du joueur
      select xp into vXP1
      from Joueur
      where id_joueur = vId_joueur;
      
      vXP1 := vXP1 + 10 - mod(vXP1, 10);
      
      update Joueur
      set xp = xp + 10 - mod(xp, 10); -- mise à jour de l'xp du joueur. mod(xp, 10) permet d'arrondir les valeurs d'xp à des dizaines

      select id_categorie into vCateg from Categorie
      where vXP1 >= xp_min
      and vXP1 <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = vId_joueur;
    end if;

  else -- cas partie multi-joueur
    -- requete pour savoir quel est le joueur qui a l'xp le plus important
    select J1.xp, J2.xp into vXP1, vXP2
    from Joueur J1, Joueur J2
    where J1.id_joueur = vId_joueur
    and J2.id_joueur = vId_joueur2;

    vDiffXP := vXP2-vXP1; -- différence d'xp entre les joueurs pour mettre à jour les xp de manière "juste"
    -- quel joueur a gagné
    -- retour de la proc partie_resultat
    if partie_resultat(pId_partie) = id_joueur_en_pseudo(vId_joueur) then -- dans le cas où c'est le joueur 1 qui a gagné
      if vDiffXP>=9 then
        vXP1 := vXP1 + 8;
        update Joueur set xp = xp + 8 where id_joueur = vId_joueur; -- rajoute 9 points maximum (10 points nécessaires au max pour changer de niveau)
      elsif vDiffXP>0 then -- rajoute la diff entre les deux joueurs si supèrieur à 0 mais infèrieur à 9
        vXP1 := vXP1 + vDiffXP + 1;
        update Joueur set xp = xp + vDiffXP + 1 where id_joueur = vId_joueur;
      elsif vDiffXP = 0 then
        vXP1 := vXP1 + 2;
        update Joueur set xp = xp + 2 where id_joueur = vId_joueur; -- rajoute 2 points si les joueurs ont la même expérience
      else
        vXP1 := vXP1 + 1;
        update Joueur set xp = xp + 1 where id_joueur = vId_joueur; -- rajoute un point d'xp si infèrieur à 0
      end if;

      select id_categorie into vCateg from Categorie
      where vXP1 >= xp_min
      and vXP1 <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = vId_joueur;

    elsif partie_resultat(pId_partie) = id_joueur_en_pseudo(vId_joueur2) then -- cas où c'est le joueur 2 qui a gagné
      if vDiffXP>=9 then
        vXP2 := vXP2 + 8;
        update Joueur set xp = xp + 8 where id_joueur = vId_joueur2;
      elsif vDiffXP>0 then
        vXP2 := vXP2 + vDiffXP + 1;
        update Joueur set xp = xp + vDiffXP + 1 where id_joueur = vId_joueur2;
      elsif vDiffXP = 0 then
        vXP2 := vXP2 + 2;
        update Joueur set xp = xp + 2 where id_joueur = vId_joueur2;
      else
        vXP2 := vXP2 + 1;
        update Joueur set xp = xp + 1 where id_joueur = vId_joueur2;
      end if;

      select id_categorie into vCateg from Categorie
      where vXP2 >= xp_min
      and vXP2 <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = vId_joueur2;

    else -- en cas d'égalité de la partie (les deux 'gagnent à moitié')
      if vDiffXP>=9 then
        vXP1 := vXP1 + 4;
        vXP2 := vXP2 + 1;
        update Joueur set xp = vXP1 where id_joueur = vId_joueur;
        update Joueur set xp = vXP2 where id_joueur = vId_joueur2;
      elsif vDiffXP>0 then
        vXP1 := vXP1 + (floor(0.5*vDiffXP)+1);
        vXP2 := vXP2 + 2;
        update Joueur set xp = vXP1 where id_joueur = vId_joueur;
        update Joueur set xp = vXP2 where id_joueur = vId_joueur2;
      elsif vDiffXP = 0 then
        vXP1 := vXP1 + 2;
        vXP2 := vXP2 + (floor(0.5*vDiffXP)+1);
        update Joueur set xp = vXP1 where id_joueur = vId_joueur;
        update Joueur set xp = vXP2 where id_joueur = vId_joueur2;
      else
        vXP1 := vXP1 + 1;
        vXP2 := vXP2 + 4;
        update Joueur set xp = vXP1 where id_joueur = vId_joueur;
        update Joueur set xp = vXP2 where id_joueur = vId_joueur2;
      end if;

      select id_categorie into vCateg from Categorie
      where vXP1 >= xp_min
      and vXP1 <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = vId_joueur;

      select id_categorie into vCateg from Categorie
      where vXP2 >= xp_min
      and vXP2 <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = vId_joueur2;

    end if;
  end if;
  
  retour := 0;
  COMMIT;
  
EXCEPTION
   when NO_DATA_FOUND then
    dbms_output.put_line('La partie ' || pId_partie || ' n''existe pas.');
    retour := NULL;
    ROLLBACK;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := NULL;
    ROLLBACK;
END;
/

-- test
declare 
  retour number;
begin
  terminer_partie(8,retour);
  DBMS_OUTPUT.put_line(retour);
end;
/

select * from Partie;

--------------------------------------------------------------------------------------------------------------
-- heure de la fin de la partie
--------------------------------------------------------------------------------------------------------------
create or replace function heure_fin_partie(
    pId_partie in Partie.id_partie%TYPE)
    return TIMESTAMP AS

  vTemps Niveau.temps_imparti%type;

BEGIN
  select temps_imparti into vTemps from Niveau n, Partie p
  where n.id_niveau = p.id_niveau
  and p.id_partie = pId_partie;

  return CURRENT_TIMESTAMP + vTemps;

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;
END;
/


-- test
begin
--terminer_partie(3, v);
DBMS_OUTPUT.put_line(heure_fin_partie(2));
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

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
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

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;
END;
/

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
  select max(heure) into vHeure -- heure du dernier coup
  from coup
  where id_partie = pId_partie;

  return vHeure;

EXCEPTION
  when NO_DATA_FOUND then
    dbms_output.put_line(pId_partie || ' n''est pas un identifiant de partie.');
    return null;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    return null;
END;
/

-- test
begin
  dbms_output.put_line(heure_partie(1)); -- rajouter des valeurs dans les tables
end ;
/
