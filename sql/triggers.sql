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

