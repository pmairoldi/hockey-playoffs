CREATE TABLE
  "events" (
    "id" INTEGER NOT NULL,
    "game_id" TEXT NOT NULL,
    "team_id" TEXT NOT NULL,
    "period" TINYINT NOT NULL,
    "time" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "video_link" TEXT DEFAULT '',
    "formal_id" TEXT NOT NULL,
    "strength" TEXT DEFAULT '',
    PRIMARY KEY ("id", "game_id", "team_id", "period", "type")
  );

CREATE TABLE
  "games" (
    "game_id" TEXT PRIMARY KEY NOT NULL,
    "away_id" TEXT NOT NULL,
    "home_id" TEXT NOT NULL,
    "away_score" TINYINT DEFAULT 0,
    "home_score" TINYINT DEFAULT 0,
    "date" TEXT DEFAULT 'tbd',
    "time" TEXT DEFAULT '',
    "tv" TEXT DEFAULT '',
    "period" TINYINT DEFAULT 0,
    "period_time" TEXT DEFAULT '20:00',
    "home_status" TEXT DEFAULT '',
    "away_status" TEXT DEFAULT '',
    "season_id" TEXT NOT NULL,
    "started" TINYINT DEFAULT 0,
    "finished" TINYINT DEFAULT 0,
    "home_highlight" TEXT DEFAULT '',
    "away_highlight" TEXT DEFAULT '',
    "home_condense" TEXT DEFAULT '',
    "away_condense" TEXT DEFAULT ''
  );

CREATE TABLE
  periods (
    game_id TEXT NOT NULL,
    team_id TEXT NOT NULL,
    period TINYINT NOT NULL,
    shots TINYINT DEFAULT 0,
    goals TINYINT DEFAULT 0,
    PRIMARY KEY (game_id, team_id, period)
  );

CREATE TABLE
  "playoff_seeds" (
    "season_id" TEXT NOT NULL,
    "home_id" TEXT NOT NULL,
    "away_id" TEXT NOT NULL,
    "conference" TEXT NOT NULL,
    "round" TINYINT NOT NULL,
    "seed" TINYINT NOT NULL,
    PRIMARY KEY ("season_id", "conference", "round", "seed")
  );

CREATE TABLE
  "teams" (
    "team_id" TEXT PRIMARY KEY NOT NULL,
    "city" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "red" TINYINT NOT NULL DEFAULT 0,
    "green" TINYINT NOT NULL DEFAULT 0,
    "blue" TINYINT NOT NULL DEFAULT 0
  );

INSERT INTO
  "teams" (team_id, city, name, red, green, blue)
VALUES
  ('ana', 'Anaheim', 'Ducks', 201, 63, 16),
  ('bos', 'Boston', 'Bruins', 205, 146, 14),
  ('buf', 'Buffalo', 'Sabres', 0, 26, 57),
  ('cgy', 'Calgary', 'Flames', 159, 19, 39),
  ('car', 'Carolina', 'Hurricanes', 159, 19, 39),
  ('chi', 'Chicago', 'Blackhawks', 159, 10, 39),
  ('col', 'Colorado', 'Avalanche', 88, 31, 49),
  ('cbj', 'Columbus', 'Blue Jackets', 0, 26, 57),
  ('dal', 'Dallas', 'Stars', 2, 57, 39),
  ('det', 'Detroit', 'Red Wings', 159, 10, 39),
  ('edm', 'Edmonton', 'Oilers', 0, 26, 57),
  ('fla', 'Florida', 'Panthers', 0, 26, 57),
  ('lak', 'Los Angeles', 'Kings', 27, 6, 85),
  ('min', 'Minnesota', 'Wild', 2, 57, 39),
  ('mtl', 'Montréal', 'Canadiens', 134, 20, 38),
  ('nsh', 'Nashville', 'Predators', 205, 146, 14),
  ('njd', 'New Jersey', 'Devils', 159, 10, 39),
  ('nyi', 'New York', 'Islanders', 201, 63, 16),
  ('nyr', 'New York', 'Rangers', 0, 46, 133),
  ('ott', 'Ottawa', 'Senators', 159, 10, 39),
  ('phi', 'Philadelphia', 'Flyers', 199, 56, 22),
  ('phx', 'Phoenix', 'Coyotes', 104, 29, 41),
  ('pit', 'Pittsburgh', 'Penguins', 167, 161, 126),
  ('sjs', 'San Jose', 'Sharks', 0, 83, 96),
  ('stl', 'St. Louis', 'Blues', 0, 41, 113),
  ('tbl', 'Tampa Bay', 'Lightning', 0, 30, 80),
  ('tor', 'Toronto', 'Maple Leafs', 0, 30, 80),
  ('van', 'Vancouver', 'Canucks', 0, 106, 53),
  ('wsh', 'Washington', 'Capitals', 158, 10, 38),
  ('wpg', 'Winnipeg', 'Jets', 0, 30, 80),
  ('atl', 'Atlanta', 'Thrashers', 0, 0, 0),
  ('uta', 'Utah', 'Mammoth', 83, 146, 201),
  ('sea', 'Seattle', 'Kraken', 113, 157, 179);
