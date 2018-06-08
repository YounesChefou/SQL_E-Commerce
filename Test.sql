DROP TABLE CHAUSSURE;
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
-- COPY CATEGORIE
--  FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/CATEGORIE.txt'
--   WITH DELIMITER '/';
--
-- COPY STOCK
-- FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/STOCK.txt'
--   WITH DELIMITER '/';
COPY CHAUSSURE(marque, nom, genre, prix)
 FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/SNEAKERS.txt'
  WITH DELIMITER '/';

COPY CHAUSSURE(marque, nom, genre, prix)
   FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/ESCARPINS.txt'
    WITH DELIMITER '/';
COPY CHAUSSURE(marque, nom, genre, prix)
 FROM '/home/lephoquebleu/Documents/SQL/Projet BDD/DERBIES.txt'
  WITH DELIMITER '/';

CREATE TABLE IF NOT EXISTS PANIER(
    compte varchar
      default current_user,
    id INT,
    produit VARCHAR,
    prix MONEY
);

-- CREATE TABLE IF NOT EXISTS COMMANDE(
--
-- )

-- CREATE or REPLACE FUNCTION recherche_par_pointure(in sexe char, in pointure int, out ref int, out modele varchar, out montant money)
--  RETURNS SETOF record AS
--  $$
--  DECLARE
--  curs1 CURSOR(Rgenre varchar, Rpointure INT) IS
--   SELECT id, marque||' '||nom, prix FROM CHAUSSURE
--     WHERE CHAUSSURE.genre=Rgenre AND CHAUSSURE.pointure=Rpointure;
--  BEGIN
--    OPEN curs1(sexe,pointure);
--      LOOP
--      FETCH curs1 INTO ref, modele, montant;
--      EXIT WHEN NOT FOUND;
--      RETURN NEXT;
--      END LOOP;
--    CLOSE curs1;
--    RETURN;
--  END;
--  $$ LANGUAGE PLPGSQL;

CREATE or REPLACE FUNCTION recherche_par_genre(in sexe char)
RETURNS SETOF record AS
$$
SELECT * FROM CHAUSSURE WHERE genre=sexe;

$$ LANGUAGE SQL;

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
-- SELECT * FROM recherche_par_pointure('F',40);
-- SELECT ajouter_panier(1);
