CREATE SCHEMA extensions;

-- make sure everybody can use everything in the extensions schema
grant usage on schema extensions to public;
grant execute on all functions in schema extensions to public;

-- include future extensions
alter default privileges in schema extensions grant execute on functions to public;

alter default privileges in schema extensions grant usage on types to public;

create extension pg_cron schema extensions;
CREATE EXTENSION postgis schema extensions;
CREATE EXTENSION postgis_raster schema extensions;
CREATE EXTENSION postgis_topology schema extensions;
CREATE EXTENSION postgis_tiger_geocoder schema extensions;
CREATE EXTENSION pgtap schema extensions;
CREATE EXTENSION pgjwt schema extensions;
CREATE EXTENSION http schema extensions;
