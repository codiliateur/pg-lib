CREATE OR REPLACE FUNCTION public.get_uuid_apptype (
  p_uuid uuid
)
RETURNS integer AS
$body$
BEGIN
	-- Extract Application type from uuid and convert it to integer
    RETURN ('x'||substring(p_uuid::varchar,17,2))::bit(8)::integer;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;
