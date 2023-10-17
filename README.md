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
    
Create view in pgadmin using query and use it as a dataset for Plane Matches:

CREATE VIEW plane_matches AS
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

    
Create view in pgadmin using query and use it it as a dataset for Anomaly Score:

create view anomaly_score as
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

Create a view called overall_most using the query below and use it as the dataset for Overall Most Current Data By Source:

CREATE view overall_most AS
SELECT
    'adsbx' AS system_name,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'adsbx'
GROUP BY system_name

UNION ALL

SELECT
    'opensky' AS system_name,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'opensky'
GROUP BY system_name;

Create a view called data_quality using the query below and use it as a dataset for Data Quality (Success or Error):

CREATE data_quality AS
SELECT
    'Successful Calculations' AS status,
    COUNT(*) AS count
FROM merge
UNION ALL
SELECT
    'Errors' AS status,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets'


Create a view called data_errors using the query below and use it as a dataset for Data Errors By Source:

CREATE VIEW data_errors AS
SELECT
    'adsbx' AS source,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets' and system = 'adsbx'
UNION ALL
SELECT
    'opensky' AS source,
    COUNT(*) AS count
FROM flags
where reason = 'unequalDatasets' and system = 'opensky'



Create view api_delay and use it as dataset for API Call Delay:

CREATE view api_delay AS
SELECT distinct
     time_request as time,
	 time_return - time_request as value,
	 'adsbx' as source
FROM adsbx
UNION ALL
SELECT
    time_request as time,
	 time_return - time_request as value,
	 'opensky' as source
FROM opensky



Create a view called age_data and use it as dataset for Age of Data by Source:

CREATE view age_data AS
SELECT distinct
     time_request as time,
	 (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (time_return - time_reported_by_source))) as value,
	 'adsbx' as source
FROM adsbx
GROUP BY time_request
UNION ALL
SELECT
    time_request as time,
	 (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (time_return - time_reported_by_source))) as value,
	 'opensky' as source
FROM opensky
GROUP BY time_request


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

Dataset for selected plane:

SELECT *
FROM adsbx
WHERE 
  $__timeFilter(TIMESTAMP 'epoch' + time_return * INTERVAL '1 second')
AND 
CASE 
  WHEN ('$icao' <> '') THEN (icao = '$icao')
  ELSE 1 = 1           
END;

SELECT *
FROM opensky
WHERE 
  $__timeFilter(TIMESTAMP 'epoch' + time_return * INTERVAL '1 second')
AND 
CASE 
  WHEN ('$icao' <> '') THEN (icao = '$icao')
  ELSE 1 = 1           
END;


