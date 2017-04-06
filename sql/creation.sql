DROP TABLE Categorie CASCADE CONSTRAINTS;
DROP TABLE Joueur CASCADE CONSTRAINTS;
DROP TABLE Partie CASCADE CONSTRAINTS;
DROP TABLE Niveau CASCADE CONSTRAINTS;
DROP TABLE Collection CASCADE CONSTRAINTS;
DROP TABLE Image CASCADE CONSTRAINTS;
DROP TABLE Carte CASCADE CONSTRAINTS;
DROP TABLE Coup CASCADE CONSTRAINTS;


-------------------------------
-- Table Categorie
-------------------------------
CREATE TABLE Categorie
  (
    id_categorie NUMBER CONSTRAINT pk_categorie PRIMARY KEY,
    libelle      VARCHAR2(25 CHAR) CONSTRAINT nn_categorie_libelle NOT NULL,
    xp_min       NUMBER CONSTRAINT nn_categorie_xp_min NOT NULL,
    xp_max       NUMBER CONSTRAINT nn_categorie_xp_max NOT NULL,

    CONSTRAINT un_categorie_libelle UNIQUE(libelle)
  );

-------------------------------
-- Table Joueur
-------------------------------
CREATE TABLE Joueur
  (
    id_joueur    NUMBER CONSTRAINT pk_joueur PRIMARY KEY,
    pseudo       VARCHAR2(40 CHAR) CONSTRAINT nn_joueur_pseudo NOT NULL,
    mail         VARCHAR2(60 CHAR) CONSTRAINT nn_joueur_mail NOT NULL,
    mdp          VARCHAR2(50 CHAR) CONSTRAINT nn_joueur_mdp NOT NULL,
    xp           NUMBER DEFAULT 0 CONSTRAINT nn_joueur_xp NOT NULL,
    id_categorie NUMBER DEFAULT 1 CONSTRAINT nn_joueur_id_categorie NOT NULL,

    CONSTRAINT fk_joueur_categorie FOREIGN KEY(id_categorie) REFERENCES Categorie,
    CONSTRAINT un_joueur_pseudo UNIQUE(pseudo),
    CONSTRAINT ck_joueur_mail CHECK(mail LIKE '%@%.%'),
    CONSTRAINT un_joueur_mail UNIQUE(mail)
  );

-------------------------------
-- Table Collection
-------------------------------
CREATE TABLE Collection
  (
    id_collection NUMBER CONSTRAINT pk_collection PRIMARY KEY
  );

-------------------------------
-- Table Niveau
-------------------------------
CREATE TABLE Niveau
  (
    id_niveau     NUMBER CONSTRAINT pk_niveau PRIMARY KEY,
    xp_requis     NUMBER CONSTRAINT nn_niveau_xp_requis NOT NULL,
    temps_imparti INTERVAL DAY TO SECOND CONSTRAINT nn_niveau_temps_imparti NOT NULL,
    nb_ligne      NUMBER CONSTRAINT nn_niveau_nb_ligne NOT NULL,
    nb_colonne    NUMBER CONSTRAINT nn_niveau_nb_colonne NOT NULL,
    id_collection NUMBER CONSTRAINT nn_niveau_id_collection NOT NULL,

    CONSTRAINT fk_niveau_collection FOREIGN KEY(id_collection) REFERENCES Collection,
    CONSTRAINT ck_id_niveau CHECK(id_niveau BETWEEN 1 AND 50)
  );

-------------------------------
-- Table Image
-------------------------------
CREATE TABLE Image
  (
    id_image      NUMBER CONSTRAINT pk_image PRIMARY KEY,
    lien          VARCHAR2(100 CHAR) CONSTRAINT nn_image_lien NOT NULL,
    id_collection NUMBER CONSTRAINT nn_image_id_collection NOT NULL,

    CONSTRAINT fk_image_collection FOREIGN KEY(id_collection) REFERENCES Collection,
    CONSTRAINT un_image_lien UNIQUE(lien)
  );

-------------------------------
-- Table Partie
-------------------------------
CREATE TABLE Partie
  (
    id_partie  NUMBER CONSTRAINT pk_partie PRIMARY KEY,
    id_niveau  NUMBER CONSTRAINT nn_partie_id_niveau NOT NULL,
    id_joueur  NUMBER CONSTRAINT nn_partie_joueur NOT NULL,
    id_joueur2 NUMBER,
    etat       VARCHAR2(8 CHAR) DEFAULT 'En cours' CONSTRAINT nn_partie_etat NOT NULL,

    CONSTRAINT fk_partie_niveau FOREIGN KEY(id_niveau) REFERENCES Niveau,
    CONSTRAINT fk_partie_joueur FOREIGN KEY(id_joueur) REFERENCES Joueur,
    CONSTRAINT fk_partie_joueur2 FOREIGN KEY(id_joueur2) REFERENCES Joueur,
    CONSTRAINT ck_partie_id_joueur check(id_joueur != id_joueur2),
    CONSTRAINT ck_partie_etat check(etat in ('En cours', 'Terminé'))
  );

-------------------------------
-- Table Carte
-------------------------------
CREATE TABLE Carte
  (
    id_carte  NUMBER CONSTRAINT pk_carte PRIMARY KEY,
    ligne     NUMBER CONSTRAINT nn_ligne NOT NULL,
    colonne   NUMBER CONSTRAINT nn_colonne NOT NULL,
    id_image  NUMBER CONSTRAINT nn_id_image NOT NULL,
    id_partie NUMBER CONSTRAINT nn_id_partie NOT NULL,

    CONSTRAINT fk_carte_image FOREIGN KEY(id_image) REFERENCES Image,
    CONSTRAINT fk_carte_partie FOREIGN KEY(id_partie) REFERENCES Partie
  );

-------------------------------
-- Table Coup
-------------------------------
CREATE TABLE Coup
  (
    id_coup   NUMBER CONSTRAINT pk_coup PRIMARY KEY,
    heure     TIMESTAMP DEFAULT CURRENT_TIMESTAMP CONSTRAINT nn_heure NOT NULL,
    id_partie NUMBER CONSTRAINT nn_coup_id_partie NOT NULL,
    id_joueur NUMBER CONSTRAINT nn_coup_id_joueur NOT NULL,
    carte1    NUMBER CONSTRAINT nn_coup_carte1 NOT NULL,
    carte2    NUMBER CONSTRAINT nn_coup_carte2 NOT NULL,

    CONSTRAINT fk_coup_partie FOREIGN KEY(id_partie) REFERENCES Partie,
    CONSTRAINT fk_coup_joueur FOREIGN KEY(id_joueur) REFERENCES Joueur,
    CONSTRAINT fk_coup_carte1 FOREIGN KEY(carte1) REFERENCES Carte,
    CONSTRAINT fk_coup_carte2 FOREIGN KEY(carte2) REFERENCES Carte
  );
