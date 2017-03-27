--------------------------------------------------------------------------------
-- High Score jour
--------------------------------------------------------------------------------

-- les fonctions id_joueur_en_pseudo()+nb_coup()+duree_partie() sont dans Github - Procédure - à la fin
CREATE OR REPLACE VIEW vue_highscore_jour AS
  SELECT id_niveau, id_joueur_en_pseudo(id_joueur) pseudo, nb_coup_partie(id_partie) nb_coup, duree_partie(id_partie) duree
  FROM Partie
  WHERE id_joueur2 is null
  AND heure_partie(id_partie) > CURRENT_TIMESTAMP - INTERVAL '1' DAY -- depuis les dernières 24h
  ORDER BY 3, 4; -- trié par nb_coup et duréed de la partie


select * from vue_highscore_jour; -- test pour regarder ce qu'on a mis dans les HS



SELECT * FROM (select * from categorie order by 2 desc)
WHERE rownum <= 3
order by rownum; -- prends les trois premières catégories de la table catégorie

--------------------------------------------------------------------------------
-- High Score semaine
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vue_highscore_semaine
  SELECT id_niveau, id_joueur_en_pseudo(id_joueur) pseudo, nb_coup_partie(id_partie) nb_coup, duree_partie(id_partie) duree
  FROM Partie
  WHERE id_joueur2 is null
  AND heure_partie(id_partie) > CURRENT_TIMESTAMP - INTERVAL '7' DAY
  ORDER BY 3, 4;


  select * from vue_highscore_semaine;



  SELECT * FROM (select * from categorie order by 2 desc)
  WHERE rownum <= 3
  order by rownum;

--------------------------------------------------------------------------------
-- High Score global
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vue_highscore_global
  SELECT id_niveau, id_joueur_en_pseudo(id_joueur) pseudo, nb_coup_partie(id_partie) nb_coup, duree_partie(id_partie) duree
  FROM Partie
  WHERE id_joueur2 is null
  ORDER BY 3, 4;


  select * from vue_highscore_global;



  SELECT * FROM (select * from categorie order by 2 desc)
  WHERE rownum <= 3
  order by rownum;

