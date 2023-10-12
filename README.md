# Carrasco_superset
Dataset for ADSB-X planes tracked:
WITH LatestTimestamp AS (
    SELECT
        MAX(time_request) AS largest_time
    FROM
        adsbx
   
)
SELECT
    COUNT(*) AS data_count
FROM
    adsbx t
JOIN
    LatestTimestamp l ON t.time_request = l.largest_time;
    
Dataset for Open Sky planes tracked:
WITH LatestTimestamp AS (
    SELECT
        MAX(time_request) AS largest_time
    FROM
        opensky

)
SELECT
    COUNT(*) AS data_count
FROM
    opensky t
JOIN
    LatestTimestamp l ON t.time_request = l.largest_time;
    
Create table in pgadmin using query and use it as a dataset for Plane Matches:
create table plane_matches as
WITH LatestTimestamp AS (
    SELECT
        MAX(time_begin) AS largest_time
    FROM
        merge
   
)
SELECT
    COUNT(*) AS data_count
FROM
    merge t
JOIN
    LatestTimestamp l ON t.time_begin = l.largest_time;
    
Create table in pgadmin using query and use it it as a dataset for Anomaly Score:
create table anomaly_score as
WITH LatestTimestamp AS (
    SELECT
        MAX(time_begin) AS largest_time
    FROM
        merge 
 
)
SELECT icao, avg_med_dist_value::float  
FROM merge t
JOIN
    LatestTimestamp l ON t.time_begin = l.largest_time
order by t.avg_med_dist_value desc limit 5

Create a table called overall_most with two columns source(text) and count(bigint). Then run these two queries and use it as a dataset for Overall Most Current Data By Source:
INSERT INTO overall_most (source,count)
VALUES ('adsbx',(SELECT Count(*) as adsbx from merge where first_sys = 'adsbx'));
INSERT INTO overall_most (source,count)
VALUES ('opensky',(SELECT Count(*) as opensky from merge where first_sys = 'opensky'));

Create a table called data_quality with two columns status(text) and count(bigint). Then run these two queries and use it as a dataset for Data Quality (Success or Error):
INSERT INTO data_quality (status,count)
VALUES ('Successful Calculations',(SELECT count(*) as "Successful Calculations" FROM merge ));
INSERT INTO data_quality (status,count)
VALUES ('Errors',(Select Count(*) as "Errors" from flags where reason = 'unequalDatasets'));

Create a table called data_errors with two columns source(text) and count(bigint). Then run these two queries and use it as a dataset for Data Errors By Source:
INSERT INTO data_errors (source,count)
VALUES ('adsbx',(Select count(*) as "adsbx" from flags where reason = 'unequalDatasets' and system = 'adsbx'));
INSERT INTO data_errors (source,count)
VALUES ('opensky',(Select count(*) as "opensky" from flags where reason = 'unequalDatasets' and system = 'opensky'));

create a table called adsbx_delay using the create statement below and change the adsbx column's name to 'value'. Add another column named source(text) with a default value of 'adsbx':
create table adsbx_delay as
SELECT distinct
  time_request as time, 
  time_return - time_request as adsbx
FROM adsbx;

create a table called opensky_delay using the create statement below and change the opensky column's name to 'value'. Add another column named source(text) with a default value of 'opensky':
create table opensky_delay as
SELECT distinct
  time_request as time, 
  time_return - time_request as opensky
FROM opensky;

Dataset for API Call Delay:
SELECT ((SELECT TO_TIMESTAMP(time) AS timestamp)), value,source
FROM adsbx_delay
UNION ALL
SELECT ((SELECT TO_TIMESTAMP(time) AS timestamp)), value,source
FROM opensky_delay;

create a table called adsbx_age using the create statement below and change the adsbx column's name to 'value'. Add another column named source(text) with a default value of 'adsbx':
create table adsbx_age as
SELECT distinct
  time_request as time, 
  (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (time_return - time_reported_by_source))) AS adsbx
FROM adsbx
GROUP BY time_request;

create a table called opensky_age using the create statement below and change the opensky column's name to 'value'. Add another column named source(text) with a default value of 'opensky':
create table opensky_age as
SELECT distinct
  time_request as time, 
  (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (time_return - time_reported_by_source))) AS opensky
FROM opensky
GROUP BY time_request;

Dataset for Age of Data by Source:
SELECT ((SELECT TO_TIMESTAMP(time) AS timestamp)), value,source
FROM adsbx_age
UNION ALL
SELECT ((SELECT TO_TIMESTAMP(time) AS timestamp)), value,source
FROM opensky_age;

Dataset for Plane geographic:
WITH LatestTimestampAdsBX AS (
    SELECT
        MAX(time_return) AS largest_time
    FROM
        adsbx
),
LatestTimestampOpenSky AS (
    SELECT
        MAX(time_return) AS largest_time
    FROM
        opensky

)
SELECT
    t.icao,
    l_adsbx.largest_time,
    t.lat,
    t.lon,
    t.track,
    'adsbx' as source
FROM
    adsbx t
JOIN
    LatestTimestampAdsBX l_adsbx ON t.time_return = l_adsbx.largest_time

UNION ALL

SELECT
    t.icao,
    l_opensky.largest_time,
    t.lat,
    t.lon,
    t.track,
    'opensky' as source
FROM
    opensky t
JOIN
    LatestTimestampOpenSky l_opensky ON t.time_return = l_opensky.largest_time;

Dataset for 
