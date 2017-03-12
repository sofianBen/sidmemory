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

-- test
begin 
  --select * from partie order by 1;
  dbms_output.put_line(partie_resultat(1));
end ;
/
