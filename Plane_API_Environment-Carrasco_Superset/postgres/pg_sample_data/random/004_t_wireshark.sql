-- Install the dblink exstension (dblink is a module that
--              supports connections to other PostgreSQL databases
--              from within a database session.)
CREATE EXTENSION IF NOT EXISTS dblink;
CREATE EXTENSION IF NOT EXISTS plpython3u;

-- Create the postgres superuser role incase it doesn't already
--              exist (we don't create it my default, since the default
--              user was named shoc)
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles  -- SELECT list can be empty for this
      WHERE  rolname = 'postgres') THEN

      CREATE ROLE postgres WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION PASSWORD 'JustKeepSwimming!';
   END IF;
END
$do$;


-- Create the test_db database if it doesn't exist
DO
$do$
BEGIN
   IF EXISTS (SELECT FROM pg_database WHERE datname = 'test_db') THEN
      RAISE NOTICE 'Database already exists';  -- optional
   ELSE
      PERFORM dblink_exec('dbname=' || current_database()  -- current db
                        , 'CREATE DATABASE test_db OWNER=''shoc''');
   END IF;
END
$do$;

-- Switch to the test_db database
SET search_path TO test_db;
\connect test_db

CREATE TABLE IF NOT EXISTS public.t_wireshark_packet
(
    "time" double precision,
    source text COLLATE pg_catalog."default",
    destination text COLLATE pg_catalog."default",
    protocol text COLLATE pg_catalog."default",
    length integer,
    info text COLLATE pg_catalog."default",
    CONSTRAINT t_wireshark_packet_pkey PRIMARY KEY ("time", "source", "destination", "protocol")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.t_wireshark_packet
    OWNER to shoc;

INSERT INTO public.t_wireshark_packet(
	"time", source, destination, protocol, length, info)
	VALUES (0,          '145.254.160.237',  '65.208.228.223', 'TCP',      62,   '3372  >  80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1'),
(0.91131,    '65.208.228.223',   '145.254.160.237','TCP',      62,   '80  >  3372 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1380 SACK_PERM=1'),
(0.91131,    '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=1 Ack=1 Win=9660 Len=0'),
(0.91131,    '145.254.160.237',  '65.208.228.223', 'HTTP',     533,  'GET /download.html HTTP/1.1'),
(1.472116,   '65.208.228.223',   '145.254.160.237','TCP',      54,   '80  >  3372 [ACK] Seq=1 Ack=480 Win=6432 Len=0'),
(1.682419,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=1 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(1.812606,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=1381 Win=9660 Len=0'),
(1.812606,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=1381 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(2.012894,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=2761 Win=9660 Len=0'),
(2.443513,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=2761 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(2.553672,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [PSH, ACK] Seq=4141 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(2.553672,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=5521 Win=9660 Len=0'),
(2.553672,   '145.254.160.237',  '145.253.2.203',  'DNS',      89,   'Standard query 0x0023 A pagead2.googlesyndication.com'),
(2.633787,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=5521 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(2.814046,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=6901 Win=9660 Len=0'),
(2.894161,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=6901 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(2.91419,    '145.253.2.203',    '145.254.160.237','DNS',      188,  'Standard query response 0x0023 A pagead2.googlesyndication.com CNAME pagead2.google.com CNAME pagead.google.akadns.net A 216.239.59.104 A ''216.239.59.99'),
(2.984291,   '145.254.160.237',  '216.239.59.99',  'HTTP',     775,  'GET /pagead/ads?client=ca-pub-2309191948673629&random=1084443430285&lmt=1082467020&format=468x60_as&output=html&url=http%3A%2F%2Fwww.ethereal.com%2Fdownload.html&color_bg=FFFFFF&color_text=333333&color_link=000000&color_url=666633&color_border=666633 HTTP/1.1'), 
(3.014334,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=8281 Win=9660 Len=0'),
(3.374852,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=8281 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(3.495025,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [PSH, ACK] Seq=9661 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(3.495025,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=11041 Win=9660 Len=0'),
(3.635227,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=11041 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(3.645241,   '216.239.59.99',    '145.254.160.237','TCP',      54,   '80  >  3371 [ACK] Seq=1 Ack=722 Win=31460 Len=0'),
(3.815486,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=12421 Win=9660 Len=0'),
(3.91563,    '216.239.59.99',    '145.254.160.237','TCP',      1484, '80  >  3371 [PSH, ACK] Seq=1 Ack=722 Win=31460 Len=1430 [TCP segment of a reassembled PDU]'),
(3.955688,   '216.239.59.99',    '145.254.160.237','HTTP',     214,  'HTTP/1.1 200 OK  (text/html)'),
(3.955688,   '145.254.160.237',  '216.239.59.99',  'TCP',      54,   '3371  >  80 [ACK] Seq=722 Ack=1591 Win=8760 Len=0'),
(4.105904,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [PSH, ACK] Seq=12421 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(4.216062,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=13801 Win=9660 Len=0'),
(4.226076,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=13801 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(4.356264,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=15181 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(4.356264,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=16561 Win=9660 Len=0'),
(4.496465,   '65.208.228.223',   '145.254.160.237','TCP',      1434, '80  >  3372 [ACK] Seq=16561 Ack=480 Win=6432 Len=1380 [TCP segment of a reassembled PDU]'),
(4.496465,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=17941 Win=9660 Len=0'),
(4.776868,   '216.239.59.99',    '145.254.160.237','TCP',      1484, '[TCP Spurious Retransmission] 80  >  3371 [PSH, ACK] Seq=1 Ack=722 Win=31460 Len=1430'),
(4.776868,   '145.254.160.237',  '216.239.59.99',  'TCP',      54,   '[TCP Dup ACK 28#1] 3371  >  80 [ACK] Seq=722 Ack=1591 Win=8760 Len=0'),
(4.846969,   '65.208.228.223',   '145.254.160.237','HTTP/XML',478,   'HTTP/1.1 200 OK'),
(5.017214,   '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=18365 Win=9236 Len=0'),
(17.905747,  '65.208.228.223',   '145.254.160.237','TCP',      54,   '80  >  3372 [FIN, ACK] Seq=18365 Ack=480 Win=6432 Len=0'),
(17.905747,  '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [ACK] Seq=480 Ack=18366 Win=9236 Len=0'),
(30.063228,  '145.254.160.237',  '65.208.228.223', 'TCP',      54,   '3372  >  80 [FIN, ACK] Seq=480 Ack=18366 Win=9236 Len=0'),
(30.393704,  '65.208.228.223',   '145.254.160.237','TCP',      54,   '80  >  3372 [ACK] Seq=18366 Ack=481 Win=6432 Len=0');

INSERT INTO public.t_wireshark_packet(
	"time", source, destination, protocol, length, info)
	VALUES (0,          '192.168.200.135',  '192.168.200.21',   'TCP',66,   '7875  >  2000 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 WS=256 SACK_PERM=1'),
(0.000053,    '192.168.200.21',   '192.168.200.135',  'TCP',66,   '2000  >  7875 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460 SACK_PERM=1 WS=128'),
(0.004573,   '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7875  >  2000 [ACK] Seq=1 Ack=1 Win=262656 Len=0'),
(0.004678,   '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7875  >  2000 [PSH, ACK] Seq=1 Ack=1 Win=262656 Len=6'),
(0.00469,    '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7875 [ACK] Seq=1 Ack=7 Win=64256 Len=0'),
(2.738481,   '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7875  >  2000 [FIN, ACK] Seq=7 Ack=1 Win=262656 Len=0'),
(2.738675,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7875 [FIN, ACK] Seq=1 Ack=8 Win=64256 Len=0'),
(2.74207,    '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7875  >  2000 [ACK] Seq=8 Ack=2 Win=262656 Len=0'),
(9.041825,   '192.168.200.135',  '192.168.200.21',   'TCP',66,   '7876  >  2000 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 WS=256 SACK_PERM=1'),
(9.041865,   '192.168.200.21',   '192.168.200.135',  'TCP',66,   '2000  >  7876 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460 SACK_PERM=1 WS=128'),
(9.047489,   '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [ACK] Seq=1 Ack=1 Win=262656 Len=0'),
(9.047526,   '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=1 Ack=1 Win=262656 Len=1460'),
(9.047543,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=1461 Win=64128 Len=0'),
(9.047559,   '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=1461 Ack=1 Win=262656 Len=1460'),
(9.047567,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=2921 Win=63488 Len=0'),
(9.04757,    '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=2921 Ack=1 Win=262656 Len=1460'),
(9.047574,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=4381 Win=62592 Len=0'),
(9.047577,   '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=4381 Ack=1 Win=262656 Len=1460'),
(9.047581,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=5841 Win=61568 Len=0'),
(9.047587,   '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=5841 Ack=1 Win=262656 Len=1460'),
(9.047592,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=7301 Win=60672 Len=0'),
(9.047595,   '192.168.200.135',  '192.168.200.21',   'TCP',1514, '7876  >  2000 [ACK] Seq=7301 Ack=1 Win=262656 Len=1460'),
(9.047598,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=8761 Win=59648 Len=0'),
(9.047601,   '192.168.200.135',  '192.168.200.21',   'TCP',813,  '7876  >  2000 [PSH, ACK] Seq=8761 Ack=1 Win=262656 Len=759'),
(9.047605,   '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=1 Ack=9520 Win=59008 Len=0'),
(17.699266,  '192.168.200.21',   '192.168.200.135',  'TCP',56,   '2000  >  7876 [PSH, ACK] Seq=1 Ack=9520 Win=64128 Len=2'),
(17.756923,  '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [ACK] Seq=9520 Ack=3 Win=262656 Len=0'),
(19.204565,  '192.168.200.21',   '192.168.200.135',  'TCP',56,   '2000  >  7876 [PSH, ACK] Seq=3 Ack=9520 Win=64128 Len=2'),
(19.262073,  '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [ACK] Seq=9520 Ack=5 Win=262656 Len=0'),
(21.427095,  '192.168.200.21',   '192.168.200.135',  'TCP',56,   '2000  >  7876 [PSH, ACK] Seq=5 Ack=9520 Win=64128 Len=2'),
(21.480052,  '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [ACK] Seq=9520 Ack=7 Win=262656 Len=0'),
(27.667394,  '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [FIN, ACK] Seq=7 Ack=9520 Win=64128 Len=0'),
(27.670937,  '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [ACK] Seq=9520 Ack=8 Win=262656 Len=0'),
(27.670958,  '192.168.200.135',  '192.168.200.21',   'TCP',60,   '7876  >  2000 [FIN, ACK] Seq=9520 Ack=8 Win=262656 Len=0'),
(27.670978,  '192.168.200.21',   '192.168.200.135',  'TCP',54,   '2000  >  7876 [ACK] Seq=8 Ack=9521 Win=64128 Len=0');

