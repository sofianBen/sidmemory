CREATE OR REPLACE VIEW vue_highscore_jour AS
  SELECT id_niveau, id_joueur_en_pseudo(id_joueur) pseudo, nb_coup_partie(id_partie) nb_coup, duree_partie(id_partie) duree
  FROM Partie
  WHERE id_joueur2 is null
  AND heure_partie(id_partie) > CURRENT_TIMESTAMP - INTERVAL '1' DAY
  ORDER BY 3, 4;


select * from vue_highscore_jour;



SELECT * FROM (select * from categorie order by 2 desc)
WHERE rownum <= 3
order by rownum;
