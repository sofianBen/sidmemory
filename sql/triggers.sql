--------------------------------------------------------------------------------------------------------------
-- maj joueur.exp et joueur.id_categorie dès qu'une partie est terminée
--------------------------------------------------------------------------------------------------------------
create or replace trigger t_a_u_partie
after update on Partie

declare
  vCateg Categorie.id_categorie%type;
  vXP1 Joueur.xp%type;
  vXP2 Joueur.xp%type;
  vDiffXP number;

begin

  if :new.etat = 'Terminé' then  --dès que la partie est terminée

    if :old.id_joueur2 is null then -- cas partie mono-joueur
      if partie_resultat(:old.id_partie) = id_joueur_en_pseudo(:old.id_joueur) then -- si la parie est gagnée
    -- partie_resultat : retourne le pseudo du gagnant si le joueur a gagner ou 'Perdu' sinon
    -- on compare ce résultat avec le pseudo du joueur
      update Joueur
      set xp = xp + 10 - mod(xp, 10); -- mise à jour de l'xp du joueur. mod(xp, 10) permet d'arrondir les valeurs d'xp à des dizaines

      select id_categorie into vCateg from Categorie
      where xp >= xp_min
      and xp <= xp_max;

      update Joueur
      set id_categorie = vCateg
      where id_joueur = :new.id_joueur;

    else -- cas partie multi-joueur
  	-- requete pour savoir quel est le joueur qui a l'xp le plus important
    	select J1.xp, J2.xp into vXP1, vXP2
    	from Joueur J1, Joueur J2
    	where J1.id_joueur = :old.id_joueur
    	and J2.id_joueur = :old.id_joueur2;

      vDiffXP := vXP2-vXP1; -- différence d'xp entre les joueurs pour mettre à jour les xp de manière "juste"
      -- quel joueur a gagné
    	-- retour de la proc partie_resultat
    	if partie_resultat(:new.id_partie) = id_joueur_en_pseudo(:new.id_joueur) then -- dans le cas où c'est le joueur 1 qui a gagné
    		if vDiffXP>=9 then
    			update Joueur set xp = xp + 8 where id_joueur = :new.id_joueur; -- rajoute 9 points maximum (10 points nécessaires au max pour changer de niveau)
    		elsif vDiffXP>0 then -- rajoute la diff entre les deux joueurs si supèrieur à 0 mais infèrieur à 9
    			upadte Joueur set xp = xp + vDiffXP + 1 where id_joueur = :new.id_joueur;
    		elsif vDiffXP = 0 then
    			update Joueur set xp = xp + 2 where id_joueur = :new.id_joueur; -- rajoute 2 points si les joueurs ont la même expérience
    		else
    			update Joueur set xp = xp + 1 where id_joueur = :new.id_joueur; -- rajoute un point d'xp si infèrieur à 0
    		end if;

        select id_categorie into vCateg from Categorie
        where xp >= xp_min
        and xp <= xp_max;

        update Joueur
        set id_categorie = vCateg
        where id_joueur = :new.id_joueur;

    	elsif partie_resultat(:new.id_partie) = id_joueur_en_pseudo(:new.id_joueur2) then -- cas où c'est le joueur 2 qui a gagné
    		if vDiffXP>=9 then
    			update Joueur set xp = xp + 8 where id_joueur = :new.id_joueur2;
    		elsif vDiffXP>0 then
    			upadte Joueur set xp = xp + vDiffXP + 1 where id_joueur = :new.id_joueur2;
    		elsif vDiffXP = 0 then
    			update Joueur set xp = xp + 2 where id_joueur = :new.id_joueur2;
    		else
    			update Joueur set xp = xp + 1 where id_joueur = :new.id_joueur2;
    		end if;

        select id_categorie into vCateg from Categorie
        where xp >= xp_min
        and xp <= xp_max;

        update Joueur
        set id_categorie = vCateg
        where id_joueur = :new.id_joueur2;

    	else -- en cas d'égalité de la partie (les deux 'gagnent à moitié')
    		if vDiffXP>=9 then
          vXP1 := vXP1 + 4;
          vXP2 := vXP2 + 1;
    			update Joueur set xp = vXP1 where id_joueur = :new.id_joueur;
          update Joueur set xp = vXP2 where id_joueur = :new.id_joueur2;
    		elsif vDiffXP>0 then
          vXP1 := vXP1 + (floor(0.5*vDiffXP)+1);
          vXP2 := vXP2 + 2;
    			update Joueur set xp = vXP1 where id_joueur = :new.id_joueur;
          update Joueur set xp = vXP2 where id_joueur = :new.id_joueur2;
    		elsif vDiffXP = 0 then
          vXP1 := vXP1 + 2;
          vXP2 := vXP2 + (floor(0.5*vDiffXP)+1);
    			update Joueur set xp = vXP1 where id_joueur = :new.id_joueur;
          update Joueur set xp = vXP2 where id_joueur = :new.id_joueur2;
    		else
          vXP1 := vXP1 + 1;
          vXP2 := vXP2 + 4;
    			update Joueur set xp = vXP1 where id_joueur = :new.id_joueur;
          update Joueur set xp = vXP2 where id_joueur = :new.id_joueur2;
    		end if;


    		select id_categorie into vCateg from Categorie
    		where vXP1 >= xp_min
    		and vXP1 <= xp_max;

    		update Joueur
    		set id_categorie = vCateg
    		where id_joueur = :new.id_joueur;

        select id_categorie into vCateg from Categorie
    		where vXP2 >= xp_min
    		and vXP2 <= xp_max;

    		update Joueur
    		set id_categorie = vCateg
    		where id_joueur = :new.id_joueur2;


      end if;
  end if;
END;
/


-------------------------------------------------------------------------------
-- Trigger qui vérifie lors de l'insertion d'une partie si les 2 joueurs n'ont 
-- pas perdu 5 parties dans l'heure
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_partie_5_defaites
BEFORE INSERT ON Partie
FOR EACH ROW

DECLARE
  vNbPartie number := 0;
  vNbPartie2 number := 0;
  
BEGIN
  select count(id_partie) INTO vNbPartie 
  from coup 
  where id_joueur = :new.id_joueur
  and heure > current_timestamp - interval '1' HOUR
  and partie_resultat(id_partie) != id_joueur_en_pseudo(id_joueur)
  and partie_resultat(id_partie) != 'Egalité';
  
  if (:new.id_joueur2 is not null) then -- A VERIFIER
    select count(id_partie) INTO vNbPartie2
    from coup 
    where id_joueur = :new.id_joueur2
    and heure > current_timestamp - interval '1' HOUR
    and partie_resultat(id_partie) != id_joueur_en_pseudo(id_joueur)
    and partie_resultat(id_partie) != 'Egalité';
  end if;
  
  if (vNbPartie >= 5)  then   
    RAISE_APPLICATION_ERROR(-20001, id_joueur_en_pseudo(:new.id_joueur) || ' a perdu 5 parties dans l''heure.');
  elsif (vNbPartie2 >= 5 ) then
    RAISE_APPLICATION_ERROR(-20002, id_joueur_en_pseudo(:new.id_joueur2) || ' a perdu 5 parties dans l''heure.');
  end if;
  
END;
/

-------------------------------------------------------------------------------
-- Trigger qui vérifie lors de l'insertion d'un coup que la partie correspondante
-- est encore en cours
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_coup_blocage
BEFORE INSERT ON Coup
FOR EACH ROW

DECLARE
  vEtat Partie.etat%TYPE;
BEGIN 
  select etat into vEtat from partie where id_partie = :new.id_partie;
  
  if vEtat = 'Terminé' then
    RAISE_APPLICATION_ERROR(-20107,'la partie est terminée, vous ne pouvez plus jouer');
  end if;
  END;
  /
  
select * from partie;

update partie set etat = 'Terminé'
where id_partie = 15;

select * from coup;

insert into coup(id_coup,id_partie,id_joueur,carte1,carte2) values(seq_coup.nextval,15,2,1,2);



-------------------------------------------------------------------------------
-- Trigger qui vérifie lors de l'insertion d'une partie que le niveau des joueurs correspondent au niveau de la partie
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_partie_corresp_niveau
BEFORE INSERT ON Partie
FOR EACH ROW

DECLARE
  vNiveauJoueur number := niveau_joueur(:new.id_joueur);
  vNiveauJoueur2 number;
BEGIN 
  if :new.joueur2 is not null then
    if :new.id_niveau > vNiveauJoueur2 and :new.id_niveau > vNiveauJoueur then
      raise_application_error(-20100,'les niveaux des deux joueurs ne correspondent pas au niveau de la partie');
    end if;
  else 
    if :new.id_niveau > vNiveauJoueur then
      raise_application_error(-20101,'le niveau du joueur ne correspond pas au niveau de la partie');
    end if;
  end if;
  
  END;
  /
  
  
  -------------------------------------------------------------------------------
-- vérifier qu'un coup a bien été produit par un joueur de la partie
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_coup_produit_joueur
BEFORE INSERT ON Coup
FOR EACH ROW

DECLARE
  vId_joueur Joueur.id_joueur%TYPE;
  vId_joueur2 Joueur.id_joueur%TYPE;
BEGIN 
  select id_joueur, id_joueur2 into vId_joueur, vId_joueur2 from Partie where id_partie = :new.id_partie;
  if vId_joueur2 is not null then 
    if vId_joueur != :new.id_joueur and vId_joueur2 != :new.id_joueur then
      raise_application_error(-20111,'les deux joueurs ne sont pas dans la partie, ils ne peuvent pas faire de coup');
    elsif vId_joueur != :new.id_joueur and vId_joueur2 = :new.id_joueur then
      raise_application_error(-20112,'le joueur '||id_joueur_en_pseudo(vId_joueur)||' n''est pas dans la partie, il ne peut pas faire de coup');
    elsif vId_joueur = :new.id_joueur and vId_joueur2 != :new.id_joueur then
      raise_application_error(-20113,'le joueur '||id_joueur_en_pseudo(vId_joueur2)||' n''est pas dans la partie, il ne peut pas faire de coup');
    end if;
  else 
    if  vId_joueur != :new.id_joueur then
      raise_application_error(-20111,'le joueur '||id_joueur_en_pseudo(vId_joueur)|| ' n''est pas dans la partie, il ne peut pas faire de coup');
    end if;
  end if;
  
END;
/

INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, 2, 1,  1, 2);

  
-------------------------------------------------------------------------------
-- vérifier qu'une carte jouée durant un coup corresponde à la partie
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_coup_carte
BEFORE INSERT ON Coup
FOR EACH ROW

DECLARE
  i number := 0;
  
BEGIN 
  for cCarte in (select id_carte from Carte where id_partie = :new.id_partie) loop
    if cCarte.id_carte = :new.carte1 or cCarte.id_carte = :new.carte2 then
      i := i + 1;
    end if;
  end loop;
   
  if i != 2 then
    raise_application_error(-20114,'les deux cartes ne correspondent pas à la partie');
  end if;
  
END;
/

INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, 2, 1,  1, 2);
