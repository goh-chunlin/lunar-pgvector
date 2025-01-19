CREATE EXTENSION vector;

SELECT typname FROM pg_type WHERE typname = 'vector';

CREATE TABLE IF NOT EXISTS embeddings (
    id TEXT PRIMARY KEY,
    vector VECTOR(768),  -- Adjust the vector size based on your model
    text TEXT
);

SELECT * FROM embeddings;

INSERT INTO embeddings (id, vector, text)
VALUES (
  'Sacerdos'' Relived Ordeal', 
  ARRAY[...],
  'Increases SPD by 6% When using Skill or Ultimate on one ally target, increases the ability-using target''s CRIT DMG by 18%, lasting for 2 turn(s). This effect can stack up to 2 time(s).')
ON CONFLICT (id) DO UPDATE
SET vector = EXCLUDED.vector, text = EXCLUDED.text;

SELECT * FROM embeddings;

SELECT id, text, vector <-> '[...]' AS distance
FROM embeddings
ORDER BY distance
LIMIT 3;
