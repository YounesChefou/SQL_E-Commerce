CREATE OR REPLACE VIEW modeles_disponibles AS
  SELECT DISTINCT marque||' '||nom as modele, genre, prix, id as ref
    FROM CHAUSSURE NATURAL JOIN STOCK
      WHERE etat=true;

CREATE OR REPLACE VIEW categories_disponibles AS
  SELECT DISTINCT CATEGORIE
    FROM CATEGORIE;


grant select on categories_disponibles to client;
grant select on modeles_disponibles to client;
