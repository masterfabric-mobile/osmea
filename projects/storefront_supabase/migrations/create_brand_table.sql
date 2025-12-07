CREATE TABLE public.brand (
  id bigint NOT NULL DEFAULT nextval('brand_id_seq'::regclass),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  logo_url text,
  description text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now(),
  CONSTRAINT brand_pkey PRIMARY KEY (id)
);