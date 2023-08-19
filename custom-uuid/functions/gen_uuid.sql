CREATE OR REPLACE FUNCTION gen_uuid (
  p_entity integer = 0,
  p_app integer = 0
)
RETURNS uuid AS
$body$
-- 4.0 revision
DECLARE
    v_ts timestamptz DEFAULT clock_timestamp();
    v_ms integer DEFAULT mod(EXTRACT(MICROSECONDS FROM now())::integer, 1000000);
    v_uuid varchar(32) DEFAULT '';
    v_entity varchar(4) DEFAULT '0000';
    v_app varchar(3) DEFAULT '000';
BEGIN
    -- Prepare Object type value
    IF (p_entity > 0) THEN
        v_entity := lpad(right(to_hex(p_entity),4),4,'0');
    END IF;

    -- Prepare Application type value
    IF (p_app > 0) THEN
    	v_app := lpad(right(to_hex(p_app),3),3,'0');
    END IF;

    -- Compile UUID in format TTTTTTTT-TTTT-TAAA-EEEE-RRRRRRRRRRRR
    ---- T - Timestamp (microsecond precision) segment (13 hex-digits)
    ---- A - Application type segment (3 hex-digits)
    ---- E - Object type segment (4 hex-digits)
    ---- R - Random segment (12 hex-digits)
    v_uuid := v_uuid || to_hex(EXTRACT(EPOCH FROM v_ts)::integer)::text
                     || lpad(to_hex(v_ms)::text,5,'0')
                     || v_app
                     || v_entity
                     || lpad(to_hex((random()*65535)::bigint),4,'0')
                     || lpad(to_hex((random()*65535)::bigint),4,'0')
                     || lpad(to_hex((random()*65535)::bigint),4,'0');
RETURN v_uuid::uuid;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
