
# adresse mail + identifiant non unique

Create or replace procedure inscription (pid_joueur Joueur.id_joueur %TYPE,
  pnom Joueur.nom %TYPE,
  pprenom Joueur.prenom %TYPE,
  pmail Joueur.mail %TYPE,
  pmdp Joueur.mdp %TYPE,) AS
  vid_joueur Joueur.id_joueur %TYPE;
  vmail Joueur.mail %TYPE;
  identifiant_nn_unique EXCEPTION;
  mail_nn_unique EXCEPTION;
BEGIN
Select id_joueur, id_mail into vid_joueur,vmail FROM Joueur
if (pid_joueur=vid_joueur) then raise identifiant_nn_unique;
if (pmail=vmail) then raise mail_nn_unique;
COMMIT;
EXCEPTION
  when identifiant_nn_unique then
    dbms_output.line("L'identifiant saisie existe déja, essayer un autre identifiant")
  when mail_nn_unique then
    dbms_output.line("Le mail saisie existe déja, saisissez un autre mail svp")
END;

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
