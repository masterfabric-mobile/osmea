CREATE TABLE public.product_variants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid,
  variant_name character varying NOT NULL,
  variant_value character varying NOT NULL,
  price_modifier numeric DEFAULT 0,
  stock_quantity integer DEFAULT 0,
  sku character varying,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT product_variants_pkey PRIMARY KEY (id),
  CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);