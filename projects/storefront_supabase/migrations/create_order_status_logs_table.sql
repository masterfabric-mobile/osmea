CREATE TABLE public.order_status_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  order_id uuid,
  previous_status character varying,
  new_status character varying,
  admin_id uuid,
  note text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT order_status_logs_pkey PRIMARY KEY (id),
  CONSTRAINT order_status_logs_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id),
  CONSTRAINT order_status_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin_users(id)
);