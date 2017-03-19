--------------------------------------------------------------------------------------------------------------
-- maj joueur.exp et joueur.id_categorie dès qu'une partie est terminée
--------------------------------------------------------------------------------------------------------------
create or replace trigger t_a_u_partie
after update on Partie

declare

begin

  if :new.etat = 'Terminé' then  --dès que la partie est terlinée
    if :old.id_joueur2 is null -- cas partie mono-joueur
    
    update Joueur
    set xp = , id_categorie = id_categorie + 1;
    
    
    else -- cas partie multi-joueur
    
    
    
    end if;
  end if;
