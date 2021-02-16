create role anon                nologin noinherit;
create role authenticated       nologin noinherit; -- "logged in" user: web_user, app_user, etc
create role services        nologin noinherit bypassrls; -- allow developers to create JWT's that bypass their policies

create user authenticator noinherit;
grant anon              to authenticator;
grant authenticated     to authenticator;
grant services      to authenticator;

grant usage                     on schema public to postgres, anon, authenticated, services;
alter default privileges in schema public grant all on tables to postgres, anon, authenticated, services;
alter default privileges in schema public grant all on functions to postgres, anon, authenticated, services;
alter default privileges in schema public grant all on sequences to postgres, anon, authenticated, services;