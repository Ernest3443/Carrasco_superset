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


--DECLARE SqlSamplesSourceDataPath text := './advData';
--DECLARE DatabaseName text := 'test_db';

SET NOCOUNT OFF;
PRINT '';
--PRINT 'Started - ' + CONVERT(varchar, GETDATE(), 121);

SET NOEXEC ON;

ALTER DATABASE test_db 
SET RECOVERY SIMPLE, 
    ANSI_NULLS ON, 
    ANSI_PADDING ON, 
    ANSI_WARNINGS ON, 
    ARITHABORT ON, 
    CONCAT_NULL_YIELDS_NULL ON, 
    QUOTED_IDENTIFIER ON, 
    NUMERIC_ROUNDABORT OFF, 
    PAGE_VERIFY CHECKSUM, 
    ALLOW_SNAPSHOT_ISOLATION OFF;
    
-- ****************************************
-- Create DDL Trigger for Database
-- ****************************************
PRINT '';
PRINT '*** Creating DDL Trigger for Database';

SET QUOTED_IDENTIFIER ON;

-- Create table to store database object creation messages
-- *** WARNING:  THIS TABLE IS INTENTIONALLY A HEAP - DO NOT ADD A PRIMARY KEY ***
CREATE TABLE DatabaseLog(
    DatabaseLogID int IDENTITY (1, 1) NOT NULL,
    PostTime datetime NOT NULL, 
    DatabaseUser sysname NOT NULL, 
    Event sysname NOT NULL, 
    Schema sysname NULL, 
    Object sysname NULL, 
    TSQL nvarchar(max) NOT NULL, 
    XmlEvent xml NOT NULL
);












    