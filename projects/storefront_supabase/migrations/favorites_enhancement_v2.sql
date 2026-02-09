-- 1. Create Favorite Groups Table
CREATE TABLE public.favorite_groups (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid(),
  name text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT favorite_groups_pkey PRIMARY KEY (id),
  CONSTRAINT favorite_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);

-- 2. Modify Favorites Table to support Brands and Groups
-- Add brand_id column
ALTER TABLE public.favorites 
ADD COLUMN brand_id bigint REFERENCES public.brand(id);

-- Add group_id column
ALTER TABLE public.favorites 
ADD COLUMN group_id uuid REFERENCES public.favorite_groups(id);

-- Make product_id nullable (since a favorite can now be a brand)
ALTER TABLE public.favorites 
ALTER COLUMN product_id DROP NOT NULL;

-- Add constraint: Must have either product_id OR brand_id, but not both (optional, or allow both if flexible, but usually mutually exclusive)
ALTER TABLE public.favorites
ADD CONSTRAINT favorites_item_check 
CHECK (
  (product_id IS NOT NULL AND brand_id IS NULL) OR 
  (product_id IS NULL AND brand_id IS NOT NULL)
);

-- Policy for Groups (RLS)
ALTER TABLE public.favorite_groups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own groups" 
ON public.favorite_groups FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own groups" 
ON public.favorite_groups FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own groups" 
ON public.favorite_groups FOR DELETE 
USING (auth.uid() = user_id);
