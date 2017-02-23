SET SERVEROUTPUT ON;

--------------------------------------------------------------------------------------------------------------
-- inscription (adresse mail + identifiant non unique)
--------------------------------------------------------------------------------------------------------------

create or replace procedure inscription(
    pPseudo in Joueur.pseudo%TYPE,
    pMail in Joueur.mail%TYPE,
    pMdp in Joueur.mdp%TYPE,
    retour out number) AS

  e_mail_un EXCEPTION;
  pragma exception_init (e_mail_un, -0001);
  e_mail_ck EXCEPTION;
  pragma exception_init (e_mail_ck, -2290);
  
BEGIN
  insert into Joueur(id_joueur, pseudo, mail, mdp) values(seq_joueur.nextval, pPseudo, pMail, pMdp);
  COMMIT;
  retour := 0;
EXCEPTION
  when e_mail_un then
    dbms_output.put_line('L''adresse mail "' || pMail || '" est déjà utilisée, veulliez en choisir une autre.');
    retour := 1;
  when e_mail_ck then
    dbms_output.put_line('L''adresse mail "' || pMail || '" est invalide, veuillez la corriger.');
    retour := 2;
  when others then
    dbms_output.put_line('Erreur inconnue '|| sqlcode || ' : '|| sqlerrm );
    retour := 9; 
END;
/

-- test
declare
  retour number;
begin 
  inscription('pablo', 'pablo@mail.com', 'mdp', retour);
  dbms_output.put_line(retour);
end ;
/

select * from Joueur order by 1;




# adresse mail incorect
Select mail int vmail FROM Joueur where id_joueur=pid_joueur
if (vmail!=pmail) then raise mail_incorect;

# mdp incorect
Select mdp int vmdp FROM Joueur where id_joueur=pid_joueur
if (vmdp!=pmdp) then raise mdp_incorect;

# identifiant nn valide

# 5 parties perdues max par heures



## Categorie par rapport au xp-min xp-max

Create or replace procedure categorie_Joueur as
  BEGIN
    for i in (Select xp From Joueur) loop
      for j in (select id_categorie, xp_min, xp_max from Categorie ) loop
        if i.xp>=j.xp_min and i.xp<=j.xp_max then
          UPDATE Client
          SET id_categorie = j.id_categorie
          WHERE id_joueur = i.id_joueur
        end if;
      end loop;
    end loop;
  END;

## niveau ; si xp >= xp-requis alors niveau débloqué

## si nb-paire-joueur1 > nb-paire-joueur2 alors gagne = 1




## Si un joueur met plus de 20 secondes pour jouer alors il passe son tour
## si un joueur est inactif depuis 2 min alors il perd
