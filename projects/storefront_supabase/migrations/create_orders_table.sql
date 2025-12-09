CREATE TABLE public.orders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  order_number character varying NOT NULL UNIQUE,
  status character varying DEFAULT 'pending'::character varying,
  subtotal numeric NOT NULL,
  tax numeric DEFAULT 0,
  shipping_cost numeric DEFAULT 0,
  total numeric NOT NULL,
  shipping_address text,
  billing_address text,
  payment_method character varying,
  payment_status character varying DEFAULT 'pending'::character varying,
  notes text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);