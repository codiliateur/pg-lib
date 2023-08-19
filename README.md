# pg-lib

## custom-uuid functions

Directory /custom-uuid/functions contains functions to work with custom generated UUID.

- public.gen_uuid(int, int)
- public.get_uuid_timestamp(uuid)
- public.get_uuid_entity(uuid)
- public.get_uuid_app(uuid)

### gen_uuid()

```
gen_uuid([[int p_entity = 0], int p_app = 0]) : uuid
```

The generated UUID has a structure

`TTTTTTTT-TTTT-TAAA-EEEE-RRRRRRRRRRRR`

where
- T - packed timestamp with microseconds precision
- A - application identifier (0..999)
- E - entity identifier (0..9999)
- R - random part

The packed timestamp allows you to sort by the time the entity ID was created.

The presence of segments with application and entity identifiers in the UUID structure allows you to visually and automatically determine the entity and application to which it belongs.

### Other functions

```
get_uuid_timestamp(uuid) : timestamp
get_uuid_entity(uuid) : integer
get_uuid_app(uuid) : integer
```

These functions allow to extract a timestamp, entity ID or application ID from the UUID.
