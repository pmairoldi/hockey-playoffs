

CREATE TABLE "events" (
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


CREATE TABLE "games" (
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


CREATE TABLE periods (game_id TEXT NOT NULL, team_id TEXT NOT NULL, period TINYINT NOT NULL, shots TINYINT DEFAULT 0, goals TINYINT DEFAULT 0, PRIMARY KEY (game_id, team_id, period));


CREATE TABLE "playoff_seeds" (
"season_id" TEXT NOT NULL,
"home_id" TEXT NOT NULL,
"away_id" TEXT NOT NULL,
"conference" TEXT NOT NULL,
"round" TINYINT NOT NULL,
"seed" TINYINT NOT NULL,
PRIMARY KEY ("season_id", "conference", "round", "seed")
);


CREATE TABLE "teams" (
"team_id" TEXT PRIMARY KEY NOT NULL,
"city" TEXT NOT NULL,
"name" TEXT NOT NULL
);
INSERT INTO "teams" VALUES ('ana', 'Anaheim', 'Ducks');
INSERT INTO "teams" VALUES ('bos', 'Boston', 'Bruins');
INSERT INTO "teams" VALUES ('buf', 'Buffalo', 'Sabres');
INSERT INTO "teams" VALUES ('cgy', 'Calgary', 'Flames');
INSERT INTO "teams" VALUES ('car', 'Carolina', 'Hurricanes');
INSERT INTO "teams" VALUES ('chi', 'Chicago', 'Blackhawks');
INSERT INTO "teams" VALUES ('col', 'Colorado', 'Avalanche');
INSERT INTO "teams" VALUES ('cbj', 'Columbus', 'Blue Jackets');
INSERT INTO "teams" VALUES ('dal', 'Dallas', 'Stars');
INSERT INTO "teams" VALUES ('det', 'Detroit', 'Red Wings');
INSERT INTO "teams" VALUES ('edm', 'Edmonton', 'Oilers');
INSERT INTO "teams" VALUES ('fla', 'Florida', 'Panthers');
INSERT INTO "teams" VALUES ('lak', 'Los Angeles', 'Kings');
INSERT INTO "teams" VALUES ('min', 'Minnesota', 'Wild');
INSERT INTO "teams" VALUES ('mtl', 'Montréal', 'Canadiens');
INSERT INTO "teams" VALUES ('nsh', 'Nashville', 'Predators');
INSERT INTO "teams" VALUES ('njd', 'New Jersey', 'Devils');
INSERT INTO "teams" VALUES ('nyi', 'New York', 'Islanders');
INSERT INTO "teams" VALUES ('nyr', 'New York', 'Rangers');
INSERT INTO "teams" VALUES ('ott', 'Ottawa', 'Senators');
INSERT INTO "teams" VALUES ('phi', 'Philadelphia', 'Flyers');
INSERT INTO "teams" VALUES ('phx', 'Phoenix', 'Coyotes');
INSERT INTO "teams" VALUES ('pit', 'Pittsburgh', 'Penguins');
INSERT INTO "teams" VALUES ('sjs', 'San Jose', 'Sharks');
INSERT INTO "teams" VALUES ('stl', 'St. Louis', 'Blues');
INSERT INTO "teams" VALUES ('tbl', 'Tampa Bay', 'Lightning');
INSERT INTO "teams" VALUES ('tor', 'Toronto', 'Maple Leafs');
INSERT INTO "teams" VALUES ('van', 'Vancouver', 'Canucks');
INSERT INTO "teams" VALUES ('wsh', 'Washington', 'Capitals');
INSERT INTO "teams" VALUES ('wpg', 'Winnipeg', 'Jets');
INSERT INTO "teams" VALUES ('atl', 'Atlanta', 'Thrashers');
