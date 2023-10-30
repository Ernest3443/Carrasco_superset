# Postgres Environment set up
## View configuration 
    
Plane Matches
- contains data from plane matches vizualization
```SQL
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
```

Anomaly Score
- contains data from anomaly score vizualization
```SQL
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
```

Overall Most Current Data By Source
- contains data from overall most current data by source vizualization
```SQL
CREATE view overall_most AS
SELECT
    'adsbx' AS source,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'adsbx'
GROUP BY source

UNION ALL

SELECT
    'opensky' AS source,
    COUNT(*) AS count
FROM merge
WHERE first_sys = 'opensky'
GROUP BY source;
```
Data Quality (Success or Error)
- contains data from data quality vizualization
```SQL
CREATE VIEW data_quality AS
SELECT 'Successful Calculations' AS status, COUNT(*) AS count
FROM merge
UNION ALL
SELECT 'Errors' AS status, COUNT(*) AS count
FROM flags
WHERE reason = 'unequalDatasets';
```

Data Errors By Source
- contains data from data errors by source vizualization
```SQL
CREATE VIEW data_errors AS
SELECT 'adsbx' AS source, COUNT(*) AS count
FROM flags
WHERE reason = 'unequalDatasets' AND system = 'adsbx'
UNION ALL
SELECT 'opensky' AS source, COUNT(*) AS count
FROM flags
WHERE reason = 'unequalDatasets' AND system = 'opensky';
```
API Call Delay
- contains data from api call delay vizualization
```SQL
CREATE view api_delay1 AS
SELECT DISTINCT adsbx.time_request AS "time",
    adsbx.time_return - adsbx.time_request AS adsbx,
    opensky.time_return - opensky.time_request AS opensky
   FROM adsbx
     JOIN opensky ON adsbx.time_request = opensky.time_request;
```

Age of Data by Source
- contains data from age of data by source vizualization
```SQL
CREATE view age_data1 AS
WITH adsbx_cte AS (
         SELECT adsbx.time_request AS "time",
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (adsbx.time_return - adsbx.time_reported_by_source)) AS adsbx
           FROM adsbx
          GROUP BY adsbx.time_request
        ), opensky_cte AS (
         SELECT opensky.time_request AS "time",
            percentile_cont(0.5::double precision) WITHIN GROUP (ORDER BY (opensky.time_return - opensky.time_reported_by_source)) AS opensky
           FROM opensky
          GROUP BY opensky.time_request
        )
 SELECT adsbx_cte."time",
    adsbx_cte.adsbx,
    opensky_cte.opensky
   FROM adsbx_cte
     JOIN opensky_cte ON adsbx_cte."time" = opensky_cte."time";
```


Selected Plane
- contains data from selected plane vizualization
``` SQl
create view selected_plane as
select icao, lat,lon,track,time_request,time_return, time_reported_by_source,'opensky'::text as source 
from opensky
union all
select icao, lat,lon,track,time_request,time_return, time_reported_by_source,'adsbx'::text as source 
from adsbx
```





