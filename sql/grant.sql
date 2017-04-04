--------------------------------------------------------------------------------------------------------------
-- Select
--------------------------------------------------------------------------------------------------------------
GRANT SELECT ON Partie TO sofian;
GRANT SELECT ON Joueur TO sofian;
GRANT SELECT ON Carte TO sofian;
GRANT SELECT ON Image TO sofian;
GRANT SELECT ON Niveau TO sofian
GRANT SELECT ON vue_highscore_jour TO sofian;
GRANT SELECT ON vue_highscore_semaine TO sofian;
GRANT SELECT ON vue_highscore_global TO sofian;

--------------------------------------------------------------------------------------------------------------
-- Execute
--------------------------------------------------------------------------------------------------------------
GRANT EXECUTE ON inscription TO sofian;
GRANT EXECUTE ON connexion TO sofian;
GRANT EXECUTE ON niveau_joueur TO sofian;
GRANT EXECUTE ON creation_partie_multi TO sofian;
GRANT EXECUTE ON creation_partie_solo TO sofian;
GRANT EXECUTE ON id_joueur_en_pseudo TO sofian;
