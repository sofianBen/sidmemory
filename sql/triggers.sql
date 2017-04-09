-------------------------------------------------------------------------------
-- Trigger qui vérifie lors de l'insertion d'une partie si les 2 joueurs n'ont 
-- pas perdu 5 parties dans l'heure
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_partie_5_defaites
BEFORE INSERT ON Partie
FOR EACH ROW

DECLARE
  vNbPartie number;
  vNbPartie2 number;
  
BEGIN
  select count(id_partie) INTO vNbPartie 
  from coup 
  where id_joueur = :new.id_joueur
  and heure >= current_timestamp - interval '1' HOUR
  and partie_resultat(id_partie) != id_joueur_en_pseudo(:new.id_joueur)
  and partie_resultat(id_partie) != 'Egalité';
  
 -- raise_application_error(-20200, 'coucou ' || vNbPartie);
  
  if (:new.id_joueur2 is not null) then 
    select count(id_partie) INTO vNbPartie2
    from coup 
    where id_joueur = :new.id_joueur2
    and heure > current_timestamp - interval '1' HOUR
    and partie_resultat(id_partie) != id_joueur_en_pseudo(:new.id_joueur2)
    and partie_resultat(id_partie) != 'Egalité';
  end if;
  
  if (vNbPartie >= 5)  then   
    RAISE_APPLICATION_ERROR(-20001, id_joueur_en_pseudo(:new.id_joueur) || ' a perdu 5 parties dans l''heure.');
  elsif (vNbPartie2 >= 5 ) then
    RAISE_APPLICATION_ERROR(-20002, id_joueur_en_pseudo(:new.id_joueur2) || ' a perdu 5 parties dans l''heure.');
  end if;
  
END;
/

-- test

declare
  retour number;

begin
  creation_partie_solo(1, 1, retour);
end;
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

declare
  ret number;
  r number;
begin
  terminer_partie(231, r);
  insert_coup(231,2,19,20,ret);
end;
/



-------------------------------------------------------------------------------
-- Trigger qui vérifie lors de l'insertion d'une partie que le niveau des joueurs sont inférieurs ou égaux au niveau de la partie
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER t_b_i_partie_corresp_niveau
BEFORE INSERT ON Partie
FOR EACH ROW

DECLARE
  vNiveauJoueur number := niveau_joueur(:new.id_joueur);
  vNiveauJoueur2 number;

BEGIN 
  if :new.id_joueur2 is not null then -- si c'est une partie multi
    vNiveauJoueur2 := niveau_joueur(:new.id_joueur2);
    if :new.id_niveau > vNiveauJoueur and :new.id_niveau > vNiveauJoueur2 then
      raise_application_error(-20100,'les niveaux des joueurs ne correspondent pas au niveau de la partie');
    elsif :new.id_niveau > vNiveauJoueur then
      raise_application_error(-20101,'le niveau du joueur ' || ID_JOUEUR_EN_PSEUDO(:new.id_joueur) || ' ne correspond pas au niveau de la partie');
    elsif :new.id_niveau > vNiveauJoueur2 then
      raise_application_error(-20102,'le niveau du joueur ' || ID_JOUEUR_EN_PSEUDO(:new.id_joueur2) || ' ne correspond pas au niveau de la partie');
    end if;
  else 
    if :new.id_niveau > vNiveauJoueur then
      raise_application_error(-20103,'le niveau du joueur ' || ID_JOUEUR_EN_PSEUDO(:new.id_joueur) || ' ne correspond pas au niveau de la partie');
    end if;
  end if;
  
END;
/

declare
ret number;
retour number;
begin

  
  creation_partie_multi(2,2,19,ret);
  DBMS_OUTPUT.put_line(ret);
end;
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
      raise_application_error(-20111,'le joueur ' ||  id_joueur_en_pseudo(:new.id_joueur) || ' n''est pas dans la partie, il ne peut pas faire de coup.');
    end if;
  else 
    if  vId_joueur != :new.id_joueur then
      raise_application_error(-20112,'le joueur '||id_joueur_en_pseudo(:new.id_joueur)|| ' n''est pas dans la partie, il ne peut pas faire de coup.');
    end if;
  end if;
  
END;
/

-- test
declare
  ret number;
  retour number;
begin
  insert_coup(250, 4, 1139, 1140, ret);
  DBMS_OUTPUT.put_line(ret);
end;
/


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
    if (cCarte.id_carte = :new.carte1) or (cCarte.id_carte = :new.carte2) then
      i := i + 1;
    end if;
  end loop;
   
  if i != 2 then
    raise_application_error(-20114,'les deux cartes ne correspondent pas à la partie : ');
  end if;
  
END;
/

-- test
declare 
  n number;
begin
  CREATION_PARTIE_SOLO(1, 1, n);
  INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) 
  VALUES (seq_coup.NEXTVAL, n, 1,  (select max(id_carte)-1 from Carte where id_partie = (select max(id_partie) from Partie)), (select max(id_carte) from Carte where id_partie = (select max(id_partie) from Partie)));
end;
/

select * from coup where id_partie = (select max(id_partie) from partie);
