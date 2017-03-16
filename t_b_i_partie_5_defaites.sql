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
  select count(id_joueur) INTO vNbPartie 
  from coup 
  where id_joueur = :new.id_joueur
  and heure > current_timestamp - interval '1' HOUR
  and partie_resultat(id_partie) != id_joueur_en_pseudo(id_joueur)
  and partie_resultat(id_partie) != 'Egalité';
  
  if (:new.id_joueur2 is not null) then -- A VERIFIER
    select count(id_joueur) INTO vNbPartie2
    from coup 
    where id_joueur = :new.id_joueur2
    and heure > current_timestamp - interval '1' HOUR
    and partie_resultat(id_partie) != id_joueur_en_pseudo(id_joueur)
    and partie_resultat(id_partie) = 'Egalité';
  end if;
  
  if (vNbPartie >= 5)  then   
    RAISE_APPLICATION_ERROR(-20001, id_joueur_en_pseudo(:new.id_joueur) || ' a perdu 5 parties dans l''heure.');
  elsif (vNbPartie2 >= 5 ) then
    RAISE_APPLICATION_ERROR(-20002, id_joueur_en_pseudo(:new.id_joueur2) || ' a perdu 5 parties dans l''heure.');
  end if;
  
END;
