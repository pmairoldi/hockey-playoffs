ALTER TABLE teams
ADD COLUMN red TINYINT NOT NULL DEFAULT 0;

ALTER TABLE teams
ADD COLUMN green TINYINT NOT NULL DEFAULT 0;

ALTER TABLE teams
ADD COLUMN blue TINYINT NOT NULL DEFAULT 0;

INSERT
OR IGNORE INTO teams (team_id, city, name)
VALUES
  ('sea', 'Seattle', 'Kraken');

INSERT
OR IGNORE INTO teams (team_id, city, name)
VALUES
  ('uta', 'Utah', 'Mammoth');

UPDATE teams
SET
  red = 201,
  green = 63,
  blue = 16
WHERE
  team_id = 'ana';

UPDATE teams
SET
  red = 205,
  green = 146,
  blue = 14
WHERE
  team_id = 'bos';

UPDATE teams
SET
  red = 0,
  green = 26,
  blue = 57
WHERE
  team_id = 'buf';

UPDATE teams
SET
  red = 159,
  green = 19,
  blue = 39
WHERE
  team_id = 'cgy';

UPDATE teams
SET
  red = 159,
  green = 19,
  blue = 39
WHERE
  team_id = 'car';

UPDATE teams
SET
  red = 159,
  green = 10,
  blue = 39
WHERE
  team_id = 'chi';

UPDATE teams
SET
  red = 88,
  green = 31,
  blue = 49
WHERE
  team_id = 'col';

UPDATE teams
SET
  red = 0,
  green = 26,
  blue = 57
WHERE
  team_id = 'cbj';

UPDATE teams
SET
  red = 2,
  green = 57,
  blue = 39
WHERE
  team_id = 'dal';

UPDATE teams
SET
  red = 159,
  green = 10,
  blue = 39
WHERE
  team_id = 'det';

UPDATE teams
SET
  red = 0,
  green = 26,
  blue = 57
WHERE
  team_id = 'edm';

UPDATE teams
SET
  red = 0,
  green = 26,
  blue = 57
WHERE
  team_id = 'fla';

UPDATE teams
SET
  red = 27,
  green = 6,
  blue = 85
WHERE
  team_id = 'lak';

UPDATE teams
SET
  red = 2,
  green = 57,
  blue = 39
WHERE
  team_id = 'min';

UPDATE teams
SET
  red = 134,
  green = 20,
  blue = 38
WHERE
  team_id = 'mtl';

UPDATE teams
SET
  red = 205,
  green = 146,
  blue = 14
WHERE
  team_id = 'nsh';

UPDATE teams
SET
  red = 159,
  green = 10,
  blue = 39
WHERE
  team_id = 'njd';

UPDATE teams
SET
  red = 201,
  green = 63,
  blue = 16
WHERE
  team_id = 'nyi';

UPDATE teams
SET
  red = 0,
  green = 46,
  blue = 133
WHERE
  team_id = 'nyr';

UPDATE teams
SET
  red = 159,
  green = 10,
  blue = 39
WHERE
  team_id = 'ott';

UPDATE teams
SET
  red = 199,
  green = 56,
  blue = 22
WHERE
  team_id = 'phi';

UPDATE teams
SET
  red = 104,
  green = 29,
  blue = 41
WHERE
  team_id = 'phx';

UPDATE teams
SET
  red = 167,
  green = 161,
  blue = 126
WHERE
  team_id = 'pit';

UPDATE teams
SET
  red = 0,
  green = 83,
  blue = 96
WHERE
  team_id = 'sjs';

UPDATE teams
SET
  red = 0,
  green = 41,
  blue = 113
WHERE
  team_id = 'stl';

UPDATE teams
SET
  red = 0,
  green = 30,
  blue = 80
WHERE
  team_id = 'tbl';

UPDATE teams
SET
  red = 0,
  green = 30,
  blue = 80
WHERE
  team_id = 'tor';

UPDATE teams
SET
  red = 0,
  green = 106,
  blue = 53
WHERE
  team_id = 'van';

UPDATE teams
SET
  red = 158,
  green = 10,
  blue = 38
WHERE
  team_id = 'wsh';

UPDATE teams
SET
  red = 0,
  green = 30,
  blue = 80
WHERE
  team_id = 'wpg';

UPDATE teams
SET
  red = 0,
  green = 0,
  blue = 0
WHERE
  team_id = 'atl';

UPDATE teams
SET
  red = 113,
  green = 157,
  blue = 179
WHERE
  team_id = 'sea';