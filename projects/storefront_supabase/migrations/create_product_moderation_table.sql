CREATE TABLE public.product_moderation (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid,
  status character varying DEFAULT 'pending'::character varying,
  admin_id uuid,
  note text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT product_moderation_pkey PRIMARY KEY (id),
  CONSTRAINT product_moderation_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_moderation_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin_users(id)
);