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
    "name" TEXT NOT NULL
  );

INSERT INTO
  "teams"
VALUES
  ('ana', 'Anaheim', 'Ducks'),
  ('bos', 'Boston', 'Bruins'),
  ('buf', 'Buffalo', 'Sabres'),
  ('cgy', 'Calgary', 'Flames'),
  ('car', 'Carolina', 'Hurricanes'),
  ('chi', 'Chicago', 'Blackhawks'),
  ('col', 'Colorado', 'Avalanche'),
  ('cbj', 'Columbus', 'Blue Jackets'),
  ('dal', 'Dallas', 'Stars'),
  ('det', 'Detroit', 'Red Wings'),
  ('edm', 'Edmonton', 'Oilers'),
  ('fla', 'Florida', 'Panthers'),
  ('lak', 'Los Angeles', 'Kings'),
  ('min', 'Minnesota', 'Wild'),
  ('mtl', 'Montréal', 'Canadiens'),
  ('nsh', 'Nashville', 'Predators'),
  ('njd', 'New Jersey', 'Devils'),
  ('nyi', 'New York', 'Islanders'),
  ('nyr', 'New York', 'Rangers'),
  ('ott', 'Ottawa', 'Senators'),
  ('phi', 'Philadelphia', 'Flyers'),
  ('phx', 'Phoenix', 'Coyotes'),
  ('pit', 'Pittsburgh', 'Penguins'),
  ('sjs', 'San Jose', 'Sharks'),
  ('stl', 'St. Louis', 'Blues'),
  ('tbl', 'Tampa Bay', 'Lightning'),
  ('tor', 'Toronto', 'Maple Leafs'),
  ('van', 'Vancouver', 'Canucks'),
  ('wsh', 'Washington', 'Capitals'),
  ('wpg', 'Winnipeg', 'Jets'),
  ('atl', 'Atlanta', 'Thrashers'),
  ('uta', 'Utah', 'Mammoth'),
  ('sea', 'Seattle', 'Kraken');