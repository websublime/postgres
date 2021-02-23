CREATE OR REPLACE FUNCTION notify_hook(
	in secret text default current_setting('jwt.secret'),
	in courier_url text default current_setting('jwt.courier_url') 
) RETURNS void AS $$

    DECLARE 
        data json;
        notification json;
    	token text;
    BEGIN
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
                          'schema', 'system/events',
                          'action', 'publish',
                          'message', json_build_object(
                            'type', 'database',
                            'record', data, 
                            'schema', TG_TABLE_SCHEMA,
                            'table', TG_TABLE_NAME,
                            'operation', TG_OP)
                          );
        
                        
        -- Execute hook request
        PERFORM content::json->'headers'->>'Authorization' FROM http((
          'POST',
           courier_url,
           ARRAY[http_header('Authorization', concat('Bearer ', token))],
           'application/json',
           notification
        )::http_request); 
    END;
    
$$ LANGUAGE plpgsql;