CREATE OR REPLACE FUNCTION public.gen_uuid (
  p_objtype integer = 0,
  p_apptype integer = 0
)
RETURNS uuid AS
$body$
-- 3.0 revision
DECLARE
    v_ts			timestamptz DEFAULT clock_timestamp();
    v_ms			integer 	DEFAULT mod(EXTRACT(MICROSECONDS FROM now())::integer, 1000000);
    v_uuid          varchar(32) DEFAULT '';
	v_objtype		varchar(4)  DEFAULT '0000';
	v_apptype		varchar(2)  DEFAULT '00';
BEGIN
	-- Prepare Object type value
    IF (p_objtype > 0) THEN
    	v_objtype := lpad(right(to_hex(p_objtype),4),4,'0');
END IF;

    -- Prepare Application type value
    IF (p_apptype > 0) THEN
    	v_apptype := lpad(right(to_hex(p_apptype),2),2,'0');
END IF;

    -- Compile UUID in format TTTTTTTT-SSSS-S0AA-OOOO-RRRRRRRRRRRR
	---- T - Timestamp segment (8 hex-digits)
    ---- S - Microseconds with .000000 precission
    ---- 0 - Reserve (1 hex-digit)
    ---- A - Application type segment	(2 hex-digits)
	---- O - Object type segment (4 hex-digits)
    ---- R - Random segment (12 hex-digits)
	v_uuid := v_uuid || to_hex(EXTRACT(EPOCH FROM v_ts)::integer)::text
    				 || lpad(to_hex(v_ms)::text,5,'0')
                     || '0'
                     || v_apptype
					 || v_objtype
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
