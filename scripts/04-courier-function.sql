CREATE OR REPLACE FUNCTION notify_hook() RETURNS TRIGGER AS $$
    DECLARE 
        data json;
        notification text;
    	token text;
        secret text;
        courier_url text;
    BEGIN
        select current_setting('jwt.secret') into secret;
        select current_setting('jwt.courier_url') into courier_url;
        
    	select sign('{"aud": "system", "email": "system@websublime.dev"}', secret) into token;
    
        -- Convert the old or new row to JSON, based on the kind of action.
        -- Action = DELETE?             -> OLD row
        -- Action = INSERT or UPDATE?   -> NEW row
        IF (TG_OP = 'DELETE') THEN
            data = row_to_json(OLD);
        ELSE
            data = row_to_json(NEW);
        END IF;
        
        -- Contruct the notification as a JSON string.
        notification = json_build_object(
                          'topic', 'system/events',
                          'action', 'publish',
                          'message', json_build_object(
                            'type', 'database',
                            'record', data, 
                            'schema', TG_TABLE_SCHEMA,
                            'table', TG_TABLE_NAME,
                            'operation', TG_OP)
                          )::text;
        
                        
        -- Execute hook request
        PERFORM status, content::json->>'data' AS data FROM http((
          'POST',
           courier_url,
           ARRAY[
               http_header('Authorization', concat('Bearer ', token))
            ],
           'application/json; charset=utf8',
           notification
        ));

        RETURN NULL;
    END;
    
$$ LANGUAGE plpgsql;