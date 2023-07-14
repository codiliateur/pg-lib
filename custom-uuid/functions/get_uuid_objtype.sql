CREATE OR REPLACE FUNCTION public.get_uuid_objtype (
  p_uuid uuid
)
RETURNS integer AS
$body$
BEGIN
	-- Extract Object type from uuid and convert it to integer
    RETURN ('x'||substring(p_uuid::varchar,20,4))::bit(16)::integer;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
