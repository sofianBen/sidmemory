-- INSERT TABLE Joueur
create SEQUENCE seq_joueur;
Insert into Joueur values (seq_joueur.NEXTVAL,'zouzou','abc@gmail.com','sid',50,2);
Insert into Joueur values (seq_joueur.NEXTVAL,'bibi','bibi@gmail.com','alcool',110,3);

-- INSERT TABLE Collection

Insert into Collection values (1);
Insert into Collection values (2);
Insert into Collection values (3);
Insert into Collection values (4);
Insert into Collection values (5);

-- INSERT TABLE NIVEAU

Insert into Niveau values (1,0,20,3,3,1);
Insert into Niveau values (2,10,20,3,4,1);
Insert into Niveau values (3,20,20,4,4,1);
Insert into Niveau values (4,30,20,4,5,1);
Insert into Niveau values (5,40,20,5,5,1);
Insert into Niveau values (6,50,20,5,6,1);
Insert into Niveau values (7,60,20,6,6,1);
Insert into Niveau values (8,70,20,6,7,1);
Insert into Niveau values (9,80,20,7,7,1);
Insert into Niveau values (10,90,20,7,8,1);
Insert into Niveau values (11,100,20,3,3,2);
Insert into Niveau values (12,110,20,3,4,2);
Insert into Niveau values (13,120,20,4,4,2);
Insert into Niveau values (14,130,20,4,5,2);
Insert into Niveau values (15,140,20,5,5,2);
Insert into Niveau values (16,150,20,5,6,2);
Insert into Niveau values (17,160,20,6,6,2);
Insert into Niveau values (18,170,20,6,7,2);
Insert into Niveau values (19,180,20,7,7,2);
Insert into Niveau values (20,190,20,7,8,2);
Insert into Niveau values (21,200,20,3,3,3);
Insert into Niveau values (22,210,20,3,4,3);
Insert into Niveau values (23,220,20,4,4,3);
Insert into Niveau values (24,230,20,4,5,3);
Insert into Niveau values (25,240,20,5,5,3);
Insert into Niveau values (26,250,20,5,6,3);
Insert into Niveau values (27,260,20,6,6,3);
Insert into Niveau values (28,270,20,6,7,3);
Insert into Niveau values (29,280,20,7,7,3);
Insert into Niveau values (30,290,20,7,8,3);
Insert into Niveau values (31,300,20,3,3,4);
Insert into Niveau values (32,310,20,3,4,4);
Insert into Niveau values (33,320,20,4,4,4);
Insert into Niveau values (34,330,20,4,5,4);
Insert into Niveau values (35,340,20,5,5,4);
Insert into Niveau values (36,350,20,5,6,4);
Insert into Niveau values (37,360,20,6,6,4);
Insert into Niveau values (38,370,20,6,7,4);
Insert into Niveau values (39,380,20,7,7,4);
Insert into Niveau values (40,390,20,7,8,4);
Insert into Niveau values (41,400,20,3,4,5);
Insert into Niveau values (42,410,20,4,4,5);
Insert into Niveau values (43,420,20,4,5,5);
Insert into Niveau values (44,430,20,5,5,5);
Insert into Niveau values (45,440,20,5,6,5);
Insert into Niveau values (46,450,20,6,6,5);
Insert into Niveau values (47,460,20,6,7,5);
Insert into Niveau values (48,470,20,7,7,5);
Insert into Niveau values (49,480,20,7,8,5);
Insert into Niveau values (50,490,20,8,8,5);

-- INSERT TABLE Image
create SEQUENCE seq_image;
Insert into Joueur values (seq_image.NEXTVAL,1,1);
Insert into Joueur values (seq_image.NEXTVAL,2,1);
Insert into Joueur values (seq_image.NEXTVAL,3,1);
Insert into Joueur values (seq_image.NEXTVAL,3,1);
