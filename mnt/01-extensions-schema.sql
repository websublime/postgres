create schema extensions;

-- make sure everybody can use everything in the extensions schema
grant usage on schema extensions to public;
grant execute on all functions in schema extensions to public;

-- include future extensions
alter default privileges in schema extensions grant execute on functions to public;
alter default privileges in schema extensions grant usage on types to public;

create extension pg_cron schema extensions;

create extension postgis schema extensions;
create extension postgis_raster schema extensions;
create extension postgis_sfcgal schema extensions;
create extension fuzzystrmatch schema extensions;
create extension address_standardizer schema extensions;
create extension address_standardizer_data_us schema extensions;

create extension pgtap schema extensions;
create extension pgcrypto schema extensions;
create extension pgjwt schema extensions;
create extension http schema extensions;

alter user postgres set search_path = "$user",extensions,public;
