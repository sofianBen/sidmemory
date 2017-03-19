DROP SEQUENCE seq_joueur;
DROP SEQUENCE seq_image;
DROP SEQUENCE seq_partie;
DROP SEQUENCE seq_carte;
DROP SEQUENCE seq_coup;


-- Insert Categorie
INSERT INTO Categorie VALUES (1, 'débutant', 0, 49);
INSERT INTO Categorie VALUES (2, 'novice', 50, 99);
INSERT INTO Categorie VALUES (3, 'intermédiaire', 100, 149);
INSERT INTO Categorie VALUES (4, 'avancé', 150, 199);
INSERT INTO Categorie VALUES (5, 'bronze', 200, 249);
INSERT INTO Categorie VALUES (6, 'argent', 250, 299);
INSERT INTO Categorie VALUES (7, 'or', 300, 349);
INSERT INTO Categorie VALUES (8, 'expert', 350, 399);
INSERT INTO Categorie VALUES (9, 'maître', 400, 449);
INSERT INTO Categorie VALUES (10, 'élite', 450, 99999);


-- Insert Joueur
CREATE SEQUENCE seq_joueur;
INSERT INTO Joueur VALUES (seq_joueur.NEXTVAL,'zouzou','abc@gmail.com','sid',0,1);
INSERT INTO Joueur VALUES (seq_joueur.NEXTVAL,'bibi','bibi@gmail.com','alcool',110,3);


-- Insert Collection
INSERT INTO Collection VALUES (1);
INSERT INTO Collection VALUES (2);
INSERT INTO Collection VALUES (3);
INSERT INTO Collection VALUES (4);
INSERT INTO Collection VALUES (5);


-- Insert Niveau
INSERT INTO Niveau VALUES (1,0,INTERVAL '20' SECOND,3,3,1);
INSERT INTO Niveau VALUES (2,10,INTERVAL '20' SECOND,3,4,1);
INSERT INTO Niveau VALUES (3,20,INTERVAL '20' SECOND,4,4,1);
INSERT INTO Niveau VALUES (4,30,INTERVAL '20' SECOND,4,5,1);
INSERT INTO Niveau VALUES (5,40,INTERVAL '20' SECOND,5,5,1);
INSERT INTO Niveau VALUES (6,50,INTERVAL '20' SECOND,5,6,1);
INSERT INTO Niveau VALUES (7,60,INTERVAL '20' SECOND,6,6,1);
INSERT INTO Niveau VALUES (8,70,INTERVAL '20' SECOND,6,7,1);
INSERT INTO Niveau VALUES (9,80,INTERVAL '20' SECOND,7,7,1);
INSERT INTO Niveau VALUES (10,90,INTERVAL '20' SECOND,7,8,1);
INSERT INTO Niveau VALUES (11,100,INTERVAL '20' SECOND,3,3,2);
INSERT INTO Niveau VALUES (12,110,INTERVAL '20' SECOND,3,4,2);
INSERT INTO Niveau VALUES (13,120,INTERVAL '20' SECOND,4,4,2);
INSERT INTO Niveau VALUES (14,130,INTERVAL '20' SECOND,4,5,2);
INSERT INTO Niveau VALUES (15,140,INTERVAL '20' SECOND,5,5,2);
INSERT INTO Niveau VALUES (16,150,INTERVAL '20' SECOND,5,6,2);
INSERT INTO Niveau VALUES (17,160,INTERVAL '20' SECOND,6,6,2);
INSERT INTO Niveau VALUES (18,170,INTERVAL '20' SECOND,6,7,2);
INSERT INTO Niveau VALUES (19,180,INTERVAL '20' SECOND,7,7,2);
INSERT INTO Niveau VALUES (20,190,INTERVAL '20' SECOND,7,8,2);
INSERT INTO Niveau VALUES (21,200,INTERVAL '20' SECOND,3,3,3);
INSERT INTO Niveau VALUES (22,210,INTERVAL '20' SECOND,3,4,3);
INSERT INTO Niveau VALUES (23,220,INTERVAL '20' SECOND,4,4,3);
INSERT INTO Niveau VALUES (24,230,INTERVAL '20' SECOND,4,5,3);
INSERT INTO Niveau VALUES (25,240,INTERVAL '20' SECOND,5,5,3);
INSERT INTO Niveau VALUES (26,250,INTERVAL '20' SECOND,5,6,3);
INSERT INTO Niveau VALUES (27,260,INTERVAL '20' SECOND,6,6,3);
INSERT INTO Niveau VALUES (28,270,INTERVAL '20' SECOND,6,7,3);
INSERT INTO Niveau VALUES (29,280,INTERVAL '20' SECOND,7,7,3);
INSERT INTO Niveau VALUES (30,290,INTERVAL '20' SECOND,7,8,3);
INSERT INTO Niveau VALUES (31,300,INTERVAL '20' SECOND,3,3,4);
INSERT INTO Niveau VALUES (32,310,INTERVAL '20' SECOND,3,4,4);
INSERT INTO Niveau VALUES (33,320,INTERVAL '20' SECOND,4,4,4);
INSERT INTO Niveau VALUES (34,330,INTERVAL '20' SECOND,4,5,4);
INSERT INTO Niveau VALUES (35,340,INTERVAL '20' SECOND,5,5,4);
INSERT INTO Niveau VALUES (36,350,INTERVAL '20' SECOND,5,6,4);
INSERT INTO Niveau VALUES (37,360,INTERVAL '20' SECOND,6,6,4);
INSERT INTO Niveau VALUES (38,370,INTERVAL '20' SECOND,6,7,4);
INSERT INTO Niveau VALUES (39,380,INTERVAL '20' SECOND,7,7,4);
INSERT INTO Niveau VALUES (40,390,INTERVAL '20' SECOND,7,8,4);
INSERT INTO Niveau VALUES (41,400,INTERVAL '20' SECOND,3,4,5);
INSERT INTO Niveau VALUES (42,410,INTERVAL '20' SECOND,4,4,5);
INSERT INTO Niveau VALUES (43,420,INTERVAL '20' SECOND,4,5,5);
INSERT INTO Niveau VALUES (44,430,INTERVAL '20' SECOND,5,5,5);
INSERT INTO Niveau VALUES (45,440,INTERVAL '20' SECOND,5,6,5);
INSERT INTO Niveau VALUES (46,450,INTERVAL '20' SECOND,6,6,5);
INSERT INTO Niveau VALUES (47,460,INTERVAL '20' SECOND,6,7,5);
INSERT INTO Niveau VALUES (48,470,INTERVAL '20' SECOND,7,7,5);
INSERT INTO Niveau VALUES (49,480,INTERVAL '20' SECOND,7,8,5);
INSERT INTO Niveau VALUES (50,490,INTERVAL '20' SECOND,8,8,5);

-- Insert Image
CREATE SEQUENCE seq_image;
--find . | sed 's/[^/]*\//|   /g;s/| *\([^| ]\)/\1/'
-- Collection 1
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/bleu rond.png', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/vert.png', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/noir.png', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rouge.png', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/vert claire.png       ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/vert rond.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/violet.png            ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rouge rond.png        ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/bleu.png              ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond marron.png       ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/orange.png            ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond rouge.png        ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond vert claire.png  ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond vert.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/gris.png              ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/jaune.png             ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/marron.png            ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond bleu.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/turquoise.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond rose.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond violet.png       ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/jaune rond.png        ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/blanc.png             ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond turquois.png     ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond gris.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/vert clair rond.png   ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond orange.png       ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond noir.png         ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/turquoise rond.png    ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rose.png              ', 1);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection1/rond jaune.png        ', 1);

--Collection2
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/034.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/022.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/054.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/010.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/068.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/027.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/053.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/019.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/021.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/020.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/009.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/011.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/014.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/046.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/015.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/049.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/043.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/016.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/013.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/031.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/006.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/038.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/037.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/052.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/048.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/045.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/028.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/060.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/051.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/012.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/047.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/050.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/055.png', 2);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection2/044.png', 2);

--Collection3
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/094.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/040.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/003.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/025.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/067.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/063.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/042.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/064.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/008.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/159.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/041.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/059.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/098.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/032.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/026.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/029.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/017.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/087.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/039.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/099.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/061.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/089.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/030.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/062.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/057.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/005.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/002.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/058.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/056.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/088.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/066.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/018.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/001.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/086.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/035.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/007.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/036.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/023.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/033.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/004.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/160.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/024.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/158.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/093.png', 3);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection3/065.png', 3);

--Collection4
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Yemen.svg.png', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_England.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/120px-Flag_of_Slovenia.svg.png       ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Ghana.svg.png                ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Russia.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Andorra.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/120px-Flag_of_Syria.svg.png          ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/120px-Flag_of_Luxembourg.svg.png     ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Italy.svg.png                ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Moldova.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_the_United_States.svg.png    ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Ireland.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Mali.svg.png                 ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Guinea.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Palestine.svg.png            ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Senegal.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_New_Zealand.svg.png          ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Mexico.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Iceland.svg.png              ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_the_Netherlands.svg.png      ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Jordan.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Iraq.svg.png                 ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Sudan.svg.png                ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/120px-Flag_of_Bolivia.svg.png        ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Côte_d''Ivoire.svg.png        ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Australia_(converted).svg.png', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Slovakia.svg.png             ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Puerto_Rico.svg.png          ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Norway.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Cuba.svg.png                 ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_France.svg.png               ', 4);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection4/Flag_of_Egypt.svg.png                ', 4);

--Collection5
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/010.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/011.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/026.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/032.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/013.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/009.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/001.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/019.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/015.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/005.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/031.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/023.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/003.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/020.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/014.jpg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/004.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/006.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/002.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/007.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/30.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/024.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/018.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/29.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/022.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/016.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/017.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/012.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/027.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/025.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/021.jpeg', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/28.jpeg ', 5);
INSERT INTO Image VALUES (seq_image.NEXTVAL, 'collections/collection5/008.jpeg', 5);


-- Insert Partie
CREATE SEQUENCE seq_partie;
INSERT INTO Partie(id_partie, id_niveau, id_joueur) VALUES (seq_partie.NEXTVAL, 1, 1);
INSERT INTO Partie VALUES (seq_partie.NEXTVAL, 2, 1, 2, 'En cours');


-- Insert Carte 
CREATE SEQUENCE seq_carte;
-- Cartes de la partie 1
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 1, 1, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 2, 2, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 3, 1, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 4, 2, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 1, 3, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 2, 4, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 3, 3, 1);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 4, 4, 1);
-- Cartes de la partie 2
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 1, 4, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 2, 4, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 3, 3, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 1, 4, 3, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 1, 2, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 2, 2, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 3, 1, 2);
INSERT INTO Carte VALUES (seq_carte.NEXTVAL, 2, 4, 1, 2);


--Insert Coup
CREATE SEQUENCE seq_coup;

INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, 1, 1,  7, 8);
INSERT INTO Coup(id_coup, id_partie, id_joueur, carte1, carte2) VALUES (seq_coup.NEXTVAL, 1, 1,  2, 3);


commit;