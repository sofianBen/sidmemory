--------------------------------------------------------------------------------------------------------------
-- Categorie par rapport au xp-min xp-max
-----

create or replace procedure categ_joueur(
	pxp in Joueur.xp%TYPE,
	retour out number) AS
  vid_categorie number;
BEGIN
	select id_categorie into vid_categorie from Categorie
	where (pxp >= xp_min and pxp < xp_max) or (pxp > xp_min and pxp <= xp_max);
  retour := vid_categorie;
EXCEPTION
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm ); 
END;
/

-- test
declare
  retour number;
begin 
  categ_joueur(102,retour);
  dbms_output.put_line(110);
end ;
/
	
	 
	 
---------------------------------------------------------------------------------------
-- Connaître si les deux cartes retournées sont paires
-----
create or replace procedure carte_paire(
	pid_carte in Carte.id_carte%TYPE,
	pid_carte2 in Carte.id_carte%TYPE,
	retour out number) AS
	
	vid_image number;
	vid_image2 number;
	
BEGIN
	select id_image into vid_image from Carte
	where id_carte = pid_carte;
	
	select id_image into vid_image2 from Carte
	where id_carte = pid_carte2;
	
	if vid_image = vid_image2 then
		retour := 1;
	else 
		retour :=0;
  end if;

EXCEPTION
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := -1; 
END;
/

-- test
declare
  retour number;
begin 
  carte_paire(1,2,retour);
  dbms_output.put_line(retour);
end ;
/
