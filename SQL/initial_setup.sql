CREATE OR REPLACE DATABASE DB_CLEAR_STRATEGY;

CREATE OR REPLACE SCHEMA pz_clear_strategy;

SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

CREATE OR REPLACE SCHEMA hz_clear_strategy;
CREATE OR REPLACE SCHEMA cz_clear_strategy;

CREATE TABLE pz_clear_strategy.football_data(
id varchar(),
match_event_id varchar(),
location_x varchar(),
location_y varchar(),
remaining_min varchar(),
power_of_shot varchar(),
knockout_match varchar(),
game_season varchar(),
remaining_sec varchar(),
distance_of_shot varchar(),
is_goal varchar(),
area_of_shot varchar(),
shot_basics varchar(),
range_of_shot varchar(),
team_name varchar(),
date_of_game varchar(),
"home/away" varchar(),
shot_id_number varchar(),
"lat/lng"  varchar(),
type_of_shot varchar(),
type_of_combined_shot varchar(),
match_id varchar(),
team_id varchar(),
remaining_min2 varchar(),
power_of_shot3 varchar(),
knockout_match4 varchar(),
remaining_sec5 varchar(),
distance_of_shot6 varchar());

CREATE OR REPLACE WAREHOUSE wh_test_clear_strategy
         WITH WAREHOUSE_TYPE = STANDARD, 
			  WAREHOUSE_SIZE = XSMALL, 
			  AUTO_SUSPEND = 300, 
			  AUTO_RESUME = true, 
			  INITIALLY_SUSPENDED = true,
			  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 60
			  STATEMENT_TIMEOUT_IN_SECONDS = 600;

SELECT * FROM pz_clear_strategy.football_data LIMIT 100;

