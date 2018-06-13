-- DROP TABLE CHAUSSURE;
CREATE TABLE IF NOT EXISTS CHAUSSURE(
    id SERIAL,
    marque VARCHAR,
    nom VARCHAR,
    genre CHAR,
    prix MONEY,
    PRIMARY KEY(id)
  );

CREATE TABLE IF NOT EXISTS STOCK(
    id INT,
    pointure INTEGER,
    quantite INTEGER,
    etat BOOLEAN,
    PRIMARY KEY(id,pointure)
);
CREATE TABLE IF NOT EXISTS CLIENT(
    username VARCHAR,
    password VARCHAR
);

CREATE TABLE IF NOT EXISTS CATEGORIE(
    id INT,
    categorie VARCHAR
);

-- COPY CHAUSSURE(marque, nom, genre, prix)
--  FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/SNEAKERS.txt'
--   WITH DELIMITER '/';
--
-- COPY CHAUSSURE(marque, nom, genre, prix)
--    FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/ESCARPINS.txt'
--     WITH DELIMITER '/';
-- COPY CHAUSSURE(marque, nom, genre, prix)
--  FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/DERBIES.txt'
--   WITH DELIMITER '/';

-- COPY CATEGORIE
--  FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/CATEGORIE.txt'
--   WITH DELIMITER '/';
--
-- COPY STOCK
-- FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/STOCK.txt'
--   WITH DELIMITER '/';

CREATE TABLE IF NOT EXISTS PANIER(
    compte varchar
      default current_user,
    id INT,
    produit VARCHAR,
    prix MONEY
);

CREATE TABLE IF NOT EXISTS COMMANDE(
  compte varchar
    default current_user,
  id_produits int[],
  produits varchar[],
  numero_commande int,
  prix_total MONEY
);

CREATE OR REPLACE FUNCTION ajouter_panier(in ref int, in pointure int)
 RETURNS BOOLEAN AS
 $$
 DECLARE
 curs2 CURSOR(Rid int) IS
   SELECT id, marque||' '||nom, prix FROM CHAUSSURE
    WHERE id=ref;
 Rid int;
 Rproduit varchar;
 Rprix money;
   BEGIN
   OPEN curs2(ref);
   FETCH curs2 INTO Rid, Rproduit, Rprix;
   INSERT INTO PANIER(id,produit,prix) VALUES (Rid, Rproduit, Rprix);
   CLOSE curs2;
     IF Rid IS NOT NULL THEN
        RETURN TRUE;
     END IF;
   RETURN FALSE;
 END;
 $$ LANGUAGE PLPGSQL;

CREATE or REPLACE FUNCTION passer_commande()
 RETURNS BOOLEAN AS $$
 DECLARE
 montant_total MONEY :=0;
 montant MONEY;
 id_cmd INT;
 produit_cmd VARCHAR;
 tab_id INT[];
 tab_produits VARCHAR[];
 i int := 1;
 curs_cmd CURSOR FOR
  SELECT id,produit,prix FROM PANIER;
 num_cmd int := ROUND( random() * 1000000 ) + 1;
 BEGIN
 OPEN curs_cmd;
    LOOP
    FETCH curs_cmd INTO id_cmd,produit_cmd,montant;
    EXIT WHEN NOT FOUND;
    montant_total = montant_total + montant;
    tab_id[i]=id_cmd;
    tab_produits[i]=produit_cmd;
    i = i+1;
    END LOOP;
    IF montant_total IS NOT NULL THEN
       INSERT INTO COMMANDE(id_produits,produits,numero_commande,prix_total) VALUES (tab_id, tab_produits, num_cmd, montant_total);
       DELETE FROM PANIER;
       RETURN TRUE;
    END IF;
  RETURN FALSE;
  END;
  $$ LANGUAGE PLPGSQL;

CREATE or REPLACE FUNCTION recherche_par_pointure(in taille int, out ref int, out modele varchar, out montant money)
 RETURNS SETOF record AS
 $$
 SELECT DISTINCT id, marque||' '||nom, prix
    FROM CHAUSSURE NATURAL JOIN STOCK
      WHERE STOCK.pointure=taille;
 $$ LANGUAGE SQL SECURITY DEFINER;

CREATE or REPLACE FUNCTION recherche_par_genre(in sexe char, out ref int, out nom varchar, out prix money)
RETURNS SETOF record AS
$$
SELECT id, marque||' '||nom, prix FROM CHAUSSURE WHERE genre=sexe;
$$ LANGUAGE SQL SECURITY DEFINER;

CREATE or REPLACE FUNCTION recherche_par_categorie(in categorieCherchee varchar,  out ref int, out modele varchar, out montant money)
RETURNS SETOF record AS
$$
DECLARE
cursCat CURSOR FOR
  SELECT id
    FROM CATEGORIE
     WHERE CATEGORIE.categorie = categorieCherchee;
cursChauss CURSOR(Rid int) IS
  SELECT id, marque||' '||nom, prix FROM CHAUSSURE
    WHERE id=Rid;
i int;
BEGIN
OPEN cursCat;
  LOOP
  FETCH cursCat INTO i;
  EXIT WHEN NOT FOUND;
  OPEN cursChauss(i);
  FETCH cursChauss INTO ref, modele, montant;
  EXIT WHEN NOT FOUND;
  RETURN NEXT;
  CLOSE cursChauss;
  END LOOP;
RETURN;
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;
