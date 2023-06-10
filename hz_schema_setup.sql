select * from pz_clear_strategy.football_data d
where d.match_id = 20000098;

drop table if exists hz_clear_strategy.dim_calendar;
create table hz_clear_strategy.dim_calendar as (
select distinct
    cast(d.date_of_game as date) as "date",
    year(cast(d.date_of_game as date)) as year,
    month(cast(d.date_of_game as date)) as month,
    day(cast(d.date_of_game as date)) as day,
    cast(to_char(cast(d.date_of_game as date),'%Y-%m') as varchar(7)) as season,
    cast(case when month(cast(d.date_of_game as date)) <= 3 then concat(year(cast(d.date_of_game as date)),'_01')
         when month(cast(d.date_of_game as date)) <= 6 then concat(year(cast(d.date_of_game as date)),'_02')
         when month(cast(d.date_of_game as date)) <= 9 then concat(year(cast(d.date_of_game as date)),'_03')
         else concat(year(cast(d.date_of_game as date)),'_04') end as varchar(7))  as year_quarter,
    case when month(cast(d.date_of_game as date)) <= 3 then '01'
         when month(cast(d.date_of_game as date)) <= 6 then '02'
         when month(cast(d.date_of_game as date)) <= 9 then '03' else'04' end as quarter,
    weekofyear(cast(d.date_of_game as date)) as week_of_year,
    dayofweek(cast(d.date_of_game as date)) as day_of_week,
    case when dayofweekiso(cast(d.date_of_game as date)) in (6,7) then 1 else 0 end as weekend    
from pz_clear_strategy.football_data d
where d.date_of_game is not null
and 1=2
--limit 100;
);

drop table if exists hz_clear_strategy.dim_area_of_shot;
create table hz_clear_strategy.dim_area_of_shot as (
    select row_number() over (order by t.area_of_shot) as id_dim_area_of_shot,
           t.area_of_shot,
           load_at
    from (
        select distinct    
            d.area_of_shot,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.area_of_shot is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.dim_shot_basics;
create table hz_clear_strategy.dim_shot_basics as (
    select row_number() over (order by t.shot_basics) as id_dim_shot_basics,
           t.shot_basics,
           load_at
    from (
        select distinct    
            d.shot_basics,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.shot_basics is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.dim_range_of_shot;
create table hz_clear_strategy.dim_range_of_shot as (
    select row_number() over (order by t.range_of_shot) as id_dim_range_of_shot,
           t.range_of_shot,
           load_at
    from (
        select distinct    
            d.range_of_shot,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.range_of_shot is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.dim_team;
create table hz_clear_strategy.dim_team as (
    select row_number() over (order by t.team_name) as id_dim_team,
           t.team_id,
           t.team_name,
           load_at
    from (
        select distinct
            cast(d.team_id as int) as team_id,
            d.team_name,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.team_name is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.dim_shot_types;
create table hz_clear_strategy.dim_shot_types as (
    select row_number() over (order by t.shot_type) as id_dim_shot_types,
           t.shot_type,
           load_at
    from (
        select distinct
            d.type_of_shot as shot_type,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.type_of_shot is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.dim_combined_shot_types;
create table hz_clear_strategy.dim_combined_shot_types as (
    select row_number() over (order by t.combined_shot_type) as id_dim_combined_shot_type,
           t.combined_shot_type,
           load_at
    from (
        select distinct
            d.type_of_combined_shot as combined_shot_type,
            sysdate() as load_at
        from pz_clear_strategy.football_data d
        where d.type_of_combined_shot is not null
        and 1=2
    ) t
);

drop table if exists hz_clear_strategy.ft_shots;
create table hz_clear_strategy.ft_shots as (
    select 
            cast(d.match_id as int) as match_id,
            cast(d.shot_id_number as int) as shot_id,
            1 as id_dim_shot_type,
            1 as id_dim_combined_shot_type,
            1 as id_dim_team,
            1 as id_dim_range_of_shot,
            1 as id_dim_shot_basics,
            1 as id_dim_area_of_shot,
            cast(location_x as int) as location_x,
            cast(location_y as int) as location_y,
            cast(d.remaining_min as int) as remaining_min_int,
            cast(d.remaining_min2 as float) as remaining_min_float,
            cast(d.power_of_shot as int) as power_of_shot_int,
            cast(d.power_of_shot3 as float) as power_of_shot_float,
            cast(d.remaining_sec as int) as remaining_sec_int,
            cast(d.remaining_sec5 as float) as remaining_sec_float,
            cast(d.distance_of_shot as int) as distance_of_shot_int,
            cast(d.distance_of_shot6 as float) as distance_of_shot_float,
            cast(d.is_goal as int) as is_goal,
            sysdate() as load_at,
            sysdate() as updated_at
        from pz_clear_strategy.football_data d
        where d.shot_id_number is not null
        and 1=2
);

drop table if exists hz_clear_strategy.ft_match;
create table hz_clear_strategy.ft_match as (
    select 
        cast(d.match_id as int) as match_id,
        cast(game_season as varchar(7)) as game_season,
        1 as id_dim_team,
        cast(date_of_game as date) as date_of_game,
        1 as id_dim_team_home,
        1 as id_dim_team_away,
        "lat/lng" as lat_lng,
        count(1) as number_of_shots,
        sum(cast(is_goal as int)) as number_of_goals,
        sysdate() as load_at,
        sysdate() as updated_at
    from pz_clear_strategy.football_data d
    where d.shot_id_number is not null
    and 1=2
    group by cast(d.match_id as int),
            cast(game_season as varchar(7)),
            cast(date_of_game as date),
            "lat/lng",
            sysdate()
);

