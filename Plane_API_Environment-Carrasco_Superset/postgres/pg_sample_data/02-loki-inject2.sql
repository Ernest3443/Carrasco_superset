-- Switch to the test_db database
SET search_path TO test_db;
\connect test_db

CREATE TABLE IF NOT EXISTS public.loki_injest2
(
    imported text COLLATE pg_catalog."default"
)
TABLESPACE pg_default;

INSERT INTO public.loki_injest2(imported)
VALUES ('{"status":"success","data":{"resultType":"streams","result":[{"stream":{"agent":"promtail","filename":"/var/log/weboutput.log","host":"SHOCD01PMLT013.local","job":"taskLog"},"values":[["1667335106397876100","{\"role\":\"SODO\",\"identifier\":\"cxzvcx\",\"activity\":\"Package Generation\",\"startTime\":\"2022-11-01T20:38:01.459Z\",\"endTime\":\"\",\"id\":2,\"version\":2}"],["1667335094832064400","{\"role\":\"SODO\",\"identifier\":\"cxzvcx\",\"activity\":\"Package Generation\",\"startTime\":\"2022-11-01T20:38:01.459Z\",\"endTime\":\"2022-11-01T20:38:14.692Z\",\"id\":2,\"version\":1}"],["1667335091310081900","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"2022-11-01T20:38:11.225Z\",\"id\":0,\"version\":5}"],["1667335081499194200","{\"role\":\"SODO\",\"identifier\":\"cxzvcx\",\"activity\":\"Package Generation\",\"startTime\":\"2022-11-01T20:38:01.459Z\",\"endTime\":\"\",\"id\":2,\"version\":0}"],["1667335071168214000","{\"role\":\"Dynamic Targeting\",\"identifier\":\"ewqr\",\"activity\":\"Positive Identification\",\"startTime\":\"2022-11-01T20:37:50.892Z\",\"endTime\":\"\",\"id\":1,\"version\":0}"],["1667334417379198400","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"\",\"id\":0,\"version\":4}"],["1667334416372841300","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"2022-11-01T20:26:56.204Z\",\"id\":0,\"version\":3}"],["1667334415369343900","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"\",\"id\":0,\"version\":2}"],["1667334414110605300","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"2022-11-01T20:26:53.938Z\",\"id\":0,\"version\":1}"],["1667334410842188900","{\"role\":\"C2DO\",\"identifier\":\"fda\",\"activity\":\"10 Line Export\",\"startTime\":\"2022-11-01T20:26:50.737Z\",\"endTime\":\"\",\"id\":0,\"version\":0}"]]}],"stats":{"summary":{"bytesProcessedPerSecond":1101571,"linesProcessedPerSecond":6596,"totalBytesProcessed":1670,"totalLinesProcessed":10,"execTime":0.001516016,"queueTime":0.000036385,"subqueries":1},"querier":{"store":{"totalChunksRef":0,"totalChunksDownloaded":0,"chunksDownloadTime":0,"chunk":{"headChunkBytes":0,"headChunkLines":0,"decompressedBytes":0,"decompressedLines":0,"compressedBytes":0,"totalDuplicates":0}}},"ingester":{"totalReached":1,"totalChunksMatched":0,"totalBatches":1,"totalLinesSent":10,"store":{"totalChunksRef":2,"totalChunksDownloaded":2,"chunksDownloadTime":152753,"chunk":{"headChunkBytes":0,"headChunkLines":0,"decompressedBytes":1670,"decompressedLines":10,"compressedBytes":544,"totalDuplicates":0}}}}}}');

CREATE TABLE IF NOT EXISTS public.loki_stream2
(
    agent text COLLATE pg_catalog."default" NOT NULL,
    filename text COLLATE pg_catalog."default",
    host text COLLATE pg_catalog."default",
    job text COLLATE pg_catalog."default",
    CONSTRAINT loki_stream2_pkey PRIMARY KEY (agent, filename, host, job)
)
TABLESPACE pg_default;

INSERT INTO public.loki_stream2(agent, filename, host, job)
(SELECT 	replace((rec->'stream'->'agent')::text, '"', '') as agent,
		replace((rec->'stream'->'filename')::text, '"', '') as filename,
		replace((rec->'stream'->'host')::text, '"', '') as host,
		replace((rec->'stream'->'job')::text, '"', '') as job
FROM 	(select json_array_elements((regexp_replace(replace(imported, '''', ''), '\\\\u001b\[\d\dm', '', 'g'))::json->'data'->'result') as rec 
		 from loki_injest2) as loki);


CREATE TABLE IF NOT EXISTS public.loki_value2
(
    agent text COLLATE pg_catalog."default" NOT NULL,
    filename text COLLATE pg_catalog."default",
    host text COLLATE pg_catalog."default",
    job text COLLATE pg_catalog."default",
    "timestamp" bigint,
    "values" text COLLATE pg_catalog."default",
    "jsonValues" jsonb
)
TABLESPACE pg_default;

INSERT INTO public.loki_value2(	agent, filename, host, job, "timestamp", "values")
(SELECT replace(((rec->'stream'->'agent')::text), '"', '') as agent,
 		replace(((rec->'stream'->'filename')::text), '"', '') as filename,
 		replace(((rec->'stream'->'host')::text), '"', '') as host,
 		replace(((rec->'stream'->'job')::text), '"', '') as job,
		(replace(((json_array_elements(rec->'values')->0)::text), '"', ''))::bigint as time,
		replace(replace(((json_array_elements(rec->'values')->1)::text), '"', ''), '\', '"') as msg
FROM (select json_array_elements((regexp_replace(replace(imported, '''', ''), '\\\\u001b\[\d\dm', '', 'g'))::json->'data'->'result') as rec 
	  from loki_injest2) as loki) ON CONFLICT DO NOTHING;


UPDATE public.loki_value2
	SET "jsonValues"=substr(values, POSITION('{' in values), POSITION('}' in values))::json
	WHERE loki_value2."jsonValues" is NULL AND POSITION('{' in values) <> 0 AND 
						POSITION('{' in values) < POSITION('}' in values);

