--------------------------------------------------------------------------------------------------------------
-- Select
--------------------------------------------------------------------------------------------------------------
GRANT SELECT ON Partie TO "21401992";
GRANT SELECT ON Joueur TO "21401992";
GRANT SELECT ON Carte TO "21401992";
GRANT SELECT ON Image TO "21401992";
GRANT SELECT ON Niveau TO "21401992";
GRANT SELECT ON Coup TO "21401992";
GRANT SELECT ON vue_highscore_jour TO "21401992";
GRANT SELECT ON vue_highscore_semaine TO "21401992";
GRANT SELECT ON vue_highscore_global TO "21401992";

--------------------------------------------------------------------------------------------------------------
-- Execute
--------------------------------------------------------------------------------------------------------------
GRANT EXECUTE ON inscription TO "21401992";
GRANT EXECUTE ON connexion TO "21401992";
GRANT EXECUTE ON niveau_joueur TO "21401992";
GRANT EXECUTE ON nb_coup_partie TO "21401992";
GRANT EXECUTE ON creation_partie_multi TO "21401992";
GRANT EXECUTE ON creation_partie_solo TO "21401992";
GRANT EXECUTE ON id_joueur_en_pseudo TO "21401992";
