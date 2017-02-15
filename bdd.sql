#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


#------------------------------------------------------------
# Table: Partie
#------------------------------------------------------------

CREATE TABLE Partie(
        id_partie NUMBER NOT NULL ,
        id_joueur NUMBER ,
        id_niveau NUMBER ,
        id_carte  NUMBER ,
        PRIMARY KEY (id_partie )
);


#------------------------------------------------------------
# Table: Niveau
#------------------------------------------------------------

CREATE TABLE Niveau(
        id_niveau     NUMBER NOT NULL ,
        xp_requis     NUMBER ,
        temps_imparti TIMESTAMP ,
        nb_ligne      NUMBER ,
        nb_colonne    NUMBER ,
        id_collection NUMBER ,
        PRIMARY KEY (id_niveau ),
        CHECK (id_niveau BETWEEN 1 and 50)
);


#------------------------------------------------------------
# Table: Image
#------------------------------------------------------------

CREATE TABLE Image(
        id_image      NUMBER NOT NULL ,
        URL           varchar2 (100) ,
        id_collection NUMBER ,
        PRIMARY KEY (id_image )
);


#------------------------------------------------------------
# Table: Categorie
#------------------------------------------------------------

CREATE TABLE Categorie(
        id_categorie NUMBER NOT NULL ,
        libelle      varchar2 (25) ,
        xp_min       NUMBER ,
        xp_max       NUMBER ,
        PRIMARY KEY (id_categorie )
);


#------------------------------------------------------------
# Table: Joueur
#------------------------------------------------------------

CREATE TABLE Joueur(
        id_joueur         NUMBER NOT NULL ,
        nom               varchar2 (25) ,
        prenom            varchar2 (25) ,
        mail              varchar2 (50) ,
        mdp               varchar2 (50) ,
        xp                NUMBER ,
        id_partie         NUMBER NOT NULL ,
        id_categorie      NUMBER ,
        PRIMARY KEY (id_joueur )
);


#------------------------------------------------------------
# Table: Coups
#------------------------------------------------------------

CREATE TABLE Coups(
        id_coups  NUMBER NOT NULL ,
        heure     TIMESTAMP ,
        id_partie NUMBER NOT NULL ,
        id_joueur NUMBER ,
        PRIMARY KEY (id_coups )
);


#------------------------------------------------------------
# Table: Collection
#------------------------------------------------------------

CREATE TABLE Collection(
        id_collection NUMBER NOT NULL ,
        id_niveau     NUMBER ,
        id_image      NUMBER ,
        PRIMARY KEY (id_collection )
);


#------------------------------------------------------------
# Table: Carte
#------------------------------------------------------------

CREATE TABLE Carte(
        id_carte  NUMBER NOT NULL ,
        n_ligne   NUMBER ,
        n_colonne NUMBER ,
        id_image  NUMBER ,
        PRIMARY KEY (id_carte )
);


ALTER TABLE Partie ADD CONSTRAINT FK_Partie_id_joueur FOREIGN KEY (id_joueur) REFERENCES Joueur(id_joueur);
ALTER TABLE Partie ADD CONSTRAINT FK_Partie_id_niveau FOREIGN KEY (id_niveau) REFERENCES Niveau(id_niveau);
ALTER TABLE Partie ADD CONSTRAINT FK_Partie_id_carte FOREIGN KEY (id_carte) REFERENCES Carte(id_carte);
ALTER TABLE Niveau ADD CONSTRAINT FK_Niveau_id_collection FOREIGN KEY (id_collection) REFERENCES Collection(id_collection);
ALTER TABLE Image ADD CONSTRAINT FK_Image_id_collection FOREIGN KEY (id_collection) REFERENCES Collection(id_collection);
ALTER TABLE Joueur ADD CONSTRAINT FK_Joueur_id_partie FOREIGN KEY (id_partie) REFERENCES Partie(id_partie);
ALTER TABLE Joueur ADD CONSTRAINT FK_Joueur_id_categorie FOREIGN KEY (id_categorie) REFERENCES Categorie(id_categorie);
ALTER TABLE Coups ADD CONSTRAINT FK_Coups_id_partie FOREIGN KEY (id_partie) REFERENCES Partie(id_partie);
ALTER TABLE Coups ADD CONSTRAINT FK_Coups_id_joueur FOREIGN KEY (id_joueur) REFERENCES Joueur(id_joueur);
ALTER TABLE Collection ADD CONSTRAINT FK_Collection_id_niveau FOREIGN KEY (id_niveau) REFERENCES Niveau(id_niveau);
ALTER TABLE Collection ADD CONSTRAINT FK_Collection_id_image FOREIGN KEY (id_image) REFERENCES Image(id_image);
ALTER TABLE Carte ADD CONSTRAINT FK_Carte_id_image FOREIGN KEY (id_image) REFERENCES Image(id_image);
