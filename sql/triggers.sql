--------------------------------------------------------------------------------------------------------------
-- maj joueur.exp et joueur.id_categorie d�s qu'une partie est termin�e
--------------------------------------------------------------------------------------------------------------
create or replace trigger t_a_u_partie
after update on Partie

declare

begin

  if :new.etat = 'Termin�' then  --d�s que la partie est terlin�e
    if :old.id_joueur2 is null -- cas partie mono-joueur
    
    update Joueur
    set xp = , id_categorie = id_categorie + 1;
    
    
    else -- cas partie multi-joueur
    
    
    
    end if;
  end if;
