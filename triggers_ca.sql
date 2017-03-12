---------------------------------------------------------------------------------------
-- Convertir un id_joueur en pseudo de joueur
---------------------------------------------------------------------------------------
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
END;
/


-- test
begin 
  dbms_output.put_line(id_joueur_en_pseudo(4));
end ;
/



---------------------------------------------------------------------------------------
-- Donne le résultat d'une partie
---------------------------------------------------------------------------------------
create or replace function partie_resultat(
	pid_partie in Partie.id_partie%TYPE) 
  return varchar2 AS
  
  vid_niveau Niveau.id_niveau%type;
  vid_joueur Joueur.id_joueur%type;
  vid_joueur2 Joueur.id_joueur%type;
  compteur number := 0;
  compteur2 number := 0;
  nb_paire number;
  retour_carte_paire number;
  
BEGIN
  -- recupération des informations
  select id_niveau, id_joueur, id_joueur2 into vid_niveau, vid_joueur, vid_joueur2 from Partie where id_partie = pid_partie;

  -- Comptage des paires pour le joueur 1
  for cCoup in (select * from Coup where id_partie = pid_partie and id_joueur = vid_joueur) loop
   carte_paire(cCoup.carte1, cCoup.carte2, retour_carte_paire);
   if (retour_carte_paire = 1) then -- si c'est une paire
      compteur := compteur + 1;
    end if;
  end loop;
  
  -- si c'est une partie solo
  if (vid_joueur2 is null) then
    select ((nb_colonne*nb_ligne)/2) into nb_paire from Niveau where id_niveau = vid_joueur; -- calcule du nombre de paire pour gagner
    if (compteur = nb_paire) then
      return id_joueur_en_pseudo(vid_joueur); -- affichage du pseudo si gagné
    else 
      return 'Perdue';
    end if;
  -- si c'est une partue multi
  else 
    -- Comptage des paires pour le joueur 2
    for cCoup2 in (select carte1, carte2 from Coup where id_partie = pid_partie and id_joueur = vid_joueur2) loop
      carte_paire(cCoup2.carte1, cCoup2.carte2, retour_carte_paire);
     if (retour_carte_paire = 1) then -- si c'est une paire
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
-- creationPartie  *** PAS FINIT ***
--------------------------------------------------------------------------------------------------------------

create or replace procedure creationPartie(
    pId_niveau in Niveau.id_niveau%type,
    pId_joueur in Joueur.id_joueur%TYPE,
    pId_joueur2 in Joueur.id_joueur%TYPE,
    retour out number) AS
  
BEGIN

  if (verification_defaites(pId_joueur)) = 0) then
    if (pId_joueur2 is not null) then
      if (verification_defaites(pId_joueur2)) = 0) then
        insert into Partie values(seq_partie.nextval, pId_niveau, pId_joueur, pId_joueur2);
        retour := 0;
      else 
        dbms_output.put_line('Le joueur ' || id_joueur_en_pseudo(pId_joueur2) || ' a perdu 5 partie dans la dernière heure');
        retour := 2;
      end if;
    else
      insert into Partie values(seq_partie.nextval, pId_niveau, pId_joueur, null);
      retour := 0;
    end if;
  else
    dbms_output.put_line('Le joueur ' || id_joueur_en_pseudo(pId_joueur2) || ' a perdu 5 partie dans la dernière heure');
    retour := 1;
  end if;
  
EXCEPTION -- à compléter
  --when 
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1; 
END;
/

-- test
declare
  retour number;
begin 
  creationPartie(1, '', 1, retour);
  dbms_output.put_line(retour);
end ;
/
-- test
begin 
  --select * from partie order by 1;
  dbms_output.put_line(partie_resultat(1));
end ;
/
