CREATE RULE CHAUSSURE_RULE IF NOT EXISTS
  AS ON INSERT
  TO CHAUSSURE
  DO INSTEAD NOTHING;

CREATE RULE STOCK_RULE IF NOT EXISTS
  AS ON INSERT
  TO STOCK
  DO INSTEAD NOTHING;

CREATE RULE CATEGORIE_RULE IF NOT EXISTS
    AS ON INSERT
    TO CATEGORIE
    DO INSTEAD NOTHING;
