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

-- Creat the SISO schema to save the SISO/ISO data into
--CREATE SCHEMA IF NOT EXISTS meped AUTHORIZATION shoc;

--------------------------------------------- END ISI TABLE
CREATE SEQUENCE public."seq_meped_uid"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public."seq_meped_uid" OWNER TO shoc;

CREATE TABLE IF NOT EXISTS public.id_table_meped
(
    uid integer NOT NULL DEFAULT nextval('public."seq_meped_uid"'::regclass),
    import_text text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT meped_pkey PRIMARY KEY (uid)
)
TABLESPACE pg_default;

ALTER TABLE public.id_table_meped OWNER to shoc;
ALTER TABLE ONLY public.id_table_meped ALTER COLUMN "uid" SET DEFAULT nextval('public."seq_meped_uid"'::regclass);

-- 1st Char
-- A - Platform
-- 
-- 2nd Char 
-- A - Airplane
-- 
-- 3rd Char
-- B - Fighter 
-- C - Cargo
-- D - Bomber
-- E/F/G - Fighter & Air Defense
-- 
-- 4/5th Char - RANDOM
-- 
-- 
-- select substring(upper(substr(md5(random()::text), 0, 255)), 0, 3);

-- CARGO PLANES
INSERT INTO public.id_table_meped (import_text) VALUES
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.1.1 C-130H'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.1.2 C-130H-30'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.1.3 C-130H-MP'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.1.4 C-130J'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.1.5 C-130J-30'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.3 DC-130'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.5 HC-130'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.1.14 CC-130'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.2.1 C-5A'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.2.2 C-5B'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.25.1 C-20F'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.25.2 C-20G'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.25.3 C-20H'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.4.25.4 C-20J'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.4.1.1 An-124'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.4.5.1 An-12BP'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.4.6.1 An-24'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.4.2 Hercules C130'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.4.7 V-22 Osprey'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.4.1 Transall C-160'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.4.9 Airbus A310'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.4.2.1 Y-7 (cargo)'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.4.6 Xian H-6U'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.4.7 Shaanxi Y-8XZ'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.4.1 Saab 340'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.13.4.1.1 N22B'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.13.4.1.2 N24A'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.120.4.1.1 CN-235 M'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.105.4.3.1 707-320C'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.105.4.3.2 ARAVA IAI-202'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.106.4.1 G.222/C-27 Spartan'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.39.4.1 CC144 Challenger'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.110.4.1 Kawasaki C-1'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.110.4.2 Kawasaki C-2'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.153.4.1 Fokker F27 Friendship'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.198.4.3 CASA CN-235'),
('AAC' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.175.4.1 PZL-Mielec M28 Skytruck');

-- BOMBERS
INSERT INTO public.id_table_meped (import_text) VALUES
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.3.1.1 B-1B'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.3.3.1 B-52G'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.3.1 Tu-160 Blackjack'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.3.2.1 Tu-16A Badger A'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.3.1 Harbin H-5 (B-5) Beagle'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.3.2.1 B-6 Badger A'),
('AAD' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.3.2.2 B-6D Badger (ASM platform)');

-- ATTACK/FIGHTERS
INSERT INTO public.id_table_meped (import_text) VALUES
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.2.2.1 A-6A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.2.2.2 A-6B'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.2.4.1 A-10A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.2.12.1 F-111E'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.2.12.2 F-111F'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.1.1 MiG-27 Flogger D'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.1.2 MiG-27K Flogger D'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.4.3 Su-17R Fitter C'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.5.1 Su-20 (S32Mk, Fitter-C)'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.5.2 Su-20R'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.6 Su-22 Fitter'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.8.1 Su-25 Frogfoot A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.10.1 Yak-38 Forger A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.2.10.2 Yak-38 Forger B'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.1.2 Sea Harrier T. Mk 4'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.1.3 Sea Harrier FRS. Mk 51'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.2.3 Harrier GR. 5'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.2.4 Harrier GR. 7'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.4.1 Tornado GR Mk 1'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.4.2 Tornado GR Mk 1A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.5.1 Jaguar GR1 Mk 1'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.5.2 Jaguar GR1 Mk 1A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.2.6.2 Hawk T Mk 1A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.1 Dassault/BAe Jaguar'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.2 Etendard IV-P'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.3.1 Super Etendard'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.4.1 Alpha Jet 2'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.4.3 Alpha Jet A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.4.4 Alpha Jet 3'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.5 Mirage 5'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.6 Crusader (Vought F-8E(FN)) (deprecated)'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.2.7 Mirage IV'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.78.2.1.2 Alpha Jet MS1'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.78.2.1.3 Alpha Jet A'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.78.2.1.4 Alpha Jet MS2'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.1 Harbin H-5 (deprecated)'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.2.1 Q-5'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.2.2 Q-5I'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.2.4 Q-5 II'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.2.5 A-5C Fantan'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.2.4 Xian Aircraft Company JH-7'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.105.2.1 IAI Kfir (Lion Cub)'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.114.2.1.1 CC-04'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.99.2.1 HAL Jaguar'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.99.2.2 HAL Kiran Mk II'),
('AAB' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.29.2.1 Embraer Super Tucano');

-- FIGHTER/DEFENSE
INSERT INTO public.id_table_meped (import_text) VALUES
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.2.1 F-14A'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.2.2 F-14D'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.3.4 F-16D'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.3.5 F-16E'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.4.3 F-4C'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.4.4 F-4D'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.4.5 F-4E'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.5.2 F-15B'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.5.3 F-15C'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.5.4 F-15D'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.5.5 F-15E'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.5.6 F-15F'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.6.1 F-22A'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.6.2 F-22B'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.9.2 F/A-18B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.9.3 F/A-18C'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.9.4 F/A-18D'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.9.5 F/A-18A (Australia)'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.10.3 F-5E Tiger II'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.10.4 F-5F'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.10.5 RF-5A'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.10.6 RF-5E Tigereye'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.12.1 F-35A CTOL'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.12.2 F-35C Naval'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.225.1.12.3 F-35B STOVL'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.1.1 MiG-31 Foxhound-A'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.2.1 MiG-29 Fulcrum A'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.2.2 MiG-29UB Fulcrum B'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.2.3 MiG-29 Fulcrum C'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.2.4 MiG-29K Fulcrum D'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.3.2 Su-27P Flanker B'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.3.3 Su-27UB Flanker C'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.3.4 Su-27K Flanker D'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.3.5 Su-27IB'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.4.1 MiG-25P Foxbat A'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.4.2 MiG-25RB Foxbat B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.4.3 MiG-25RBV Foxbat B'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.4.4 MiG-25BBT Foxbat B'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.4.5 MiG-25R Foxbat B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.5.2 MiG-23MF Flogger B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.5.3 MiG-23UB Flogger C'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.5.4 MiG-23UM Flogger C'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.5.5 MiG-23MF Flogger E'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.3 MiG-21PFM Fishbed F'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.4 MiG-21R Fishbed H'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.5 MiG-21S Fishbed H'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.6 MiG-21RF Fishbed H'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.15 MiG-21U Mongol A'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.6.16 MiG-21US Mongol B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.2 Su-30M2'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.3 Su-30MKI'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.4 Su-30MKK'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.5 Su-30MKM'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.6 Su-30MKA'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.222.1.19.7 Su-30SM'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.1.1.1 Tornado F. Mk2'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.1.1.2 Tornado F. Mk 2A'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.1.1.3 Tornado F. Mk 3'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.224.1.3 Eurofighter 2000'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.4 F1-BD'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.5 F1-BE'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.6 F1-BJ'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.7 F1-BK'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.21 F1-EDA'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.22 F1-EE'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.23 F1-EH'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.24 F1-EJ'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.1.25 F1-EQ'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.3 Mirage 2000C'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.4 Mirage 2000D'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.5 Mirage 2000DAD'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.6 Mirage 2000DP'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.7 Mirage 2000E'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.4.8 Mirage 2000EAD'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.5.1 Rafale B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.5.2 Rafale C'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.5.3 Rafale S-1 Standard'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.5.4 Rafale M'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.71.1.6 Mirage 50'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.78.1.4 EFM (Enhanced Fighter Maneuverability) X-31A'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.1.1 J-6II (F-6II)'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.2.1 J-7 II'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.2.2 J-7 E'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.2.3 J-7 / F-7 III'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.3.1 J-8 I Finback A'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.3.2 J-8 II Finback B'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.3.3 J-8IIF (J-8F)'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.5.2 J-10S'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.5.3 J-10AH'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.5.4 J-10B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.5.5 FC-20'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.6.2 J-11A'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.6.3 J-11B'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.6.4 J-11BS'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.6.5 J-11BH'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.45.1.6.6 J-16'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.2.1 AJ 3737'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.2.2 SK 3738'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.2.3 SF 3739'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.2.4 SH 3740'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.3.2 JAS 39B'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.3.3 JAS 39C'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.205.1.3.4 JAS 39D'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.102.8.1.1 Adnan I'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.105.1.2.1 C-7'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.105.1.3 I A I Lavi'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.106.1.1.1 AMX-T'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.106.1.2 MB 339'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.106.1.3 MB-326'),
('AAF' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.99.1.1 HAL Tejas'),
('AAG' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.110.1.1 Mitsubishi F-2'),
('AAE' || substring(upper(substr(md5(random()::text), 0, 255)), 0, 3) || '1.2.208.1.1 Ching-kuo (IDF)');

