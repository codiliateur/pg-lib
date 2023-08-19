CREATE OR REPLACE FUNCTION get_uuid_timestamp (
  p_uuid uuid
)
RETURNS TIMESTAMP WITHOUT TIME ZONE AS
$body$
DECLARE
s_uuid VARCHAR(32) DEFAULT replace(p_uuid::VARCHAR(36),'-','');
BEGIN
    -- Extract Timestamp from uuid and convert it to integer
    RETURN
        to_timestamp(('x'||left(s_uuid,8))::bit(32)::integer::double precision +
        ('x0'||substring(s_uuid,9,5))::bit(24)::integer::double precision/1000000);
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
