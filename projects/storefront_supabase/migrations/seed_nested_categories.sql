-- 1. Ana Kategorileri Ekle (Varsa atla)
INSERT INTO public.categories (name, slug, description)
VALUES
('Electronics', 'electronics', 'Technology and gadgets'),
('Fashion', 'fashion', 'Clothing and style'),
('Home & Garden', 'home-garden', 'Everything for your home'),
('Beauty', 'beauty', 'Cosmetics and personal care'),
('Sports', 'sports', 'Gear and activewear'),
('Books', 'books', 'Books and literature')
ON CONFLICT (slug) DO NOTHING;

-- 2. ELECTRONICS HİYERARŞİSİ
DO $$
DECLARE
    cat_elec uuid;
    cat_comp uuid;
    cat_phone uuid;
    cat_smart uuid;
BEGIN
    SELECT id INTO cat_elec FROM public.categories WHERE slug = 'electronics';
    
    IF cat_elec IS NOT NULL THEN
        -- Level 1
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Computers', 'computers', cat_elec),
        ('Phones', 'phones', cat_elec),
        ('Smart Home', 'smart-home', cat_elec),
        ('TV & Audio', 'tv-audio', cat_elec)
        ON CONFLICT (slug) DO NOTHING;
        
        -- Level 2: Computers
        SELECT id INTO cat_comp FROM public.categories WHERE slug = 'computers';
        IF cat_comp IS NOT NULL THEN
            INSERT INTO public.categories (name, slug, parent_id) VALUES
            ('Laptops', 'laptops', cat_comp),
            ('Desktops', 'desktops', cat_comp),
            ('Monitors', 'monitors', cat_comp),
            ('Gaming Gear', 'gaming-gear', cat_comp)
            ON CONFLICT (slug) DO NOTHING;
        END IF;

        -- Level 2: Phones
        SELECT id INTO cat_phone FROM public.categories WHERE slug = 'phones';
        IF cat_phone IS NOT NULL THEN
            INSERT INTO public.categories (name, slug, parent_id) VALUES
            ('Smartphones', 'smartphones', cat_phone),
            ('Phone Cases', 'phone-cases', cat_phone),
            ('Chargers', 'chargers', cat_phone)
            ON CONFLICT (slug) DO NOTHING;
        END IF;

        -- Level 2: Smart Home
        SELECT id INTO cat_smart FROM public.categories WHERE slug = 'smart-home';
        IF cat_smart IS NOT NULL THEN
            INSERT INTO public.categories (name, slug, parent_id) VALUES
            ('Cameras', 'smart-cameras', cat_smart),
            ('Lighting', 'smart-lighting', cat_smart),
            ('Voice Assistants', 'voice-assistants', cat_smart)
            ON CONFLICT (slug) DO NOTHING;
        END IF;
    END IF;
END $$;

-- 3. FASHION HİYERARŞİSİ
DO $$
DECLARE
    cat_fash uuid;
    cat_cloth uuid;
    cat_shoes uuid;
    cat_men uuid;
    cat_women uuid;
BEGIN
    SELECT id INTO cat_fash FROM public.categories WHERE slug = 'fashion';
    
    IF cat_fash IS NOT NULL THEN
        -- Level 1
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Clothing', 'clothing', cat_fash),
        ('Shoes', 'shoes', cat_fash),
        ('Accessories', 'accessories', cat_fash),
        ('Watches', 'watches', cat_fash)
        ON CONFLICT (slug) DO NOTHING;

        -- Level 2: Clothing
        SELECT id INTO cat_cloth FROM public.categories WHERE slug = 'clothing';
        IF cat_cloth IS NOT NULL THEN
            INSERT INTO public.categories (name, slug, parent_id) VALUES
            ('Men''s Clothing', 'mens-clothing', cat_cloth),
            ('Women''s Clothing', 'womens-clothing', cat_cloth),
            ('Kids'' Clothing', 'kids-clothing', cat_cloth)
            ON CONFLICT (slug) DO NOTHING;
            
            -- Level 3: Men's Clothing
            SELECT id INTO cat_men FROM public.categories WHERE slug = 'mens-clothing';
            IF cat_men IS NOT NULL THEN
                INSERT INTO public.categories (name, slug, parent_id) VALUES
                ('Men''s T-Shirts', 'mens-tshirts', cat_men),
                ('Men''s Jeans', 'mens-jeans', cat_men),
                ('Suits', 'suits', cat_men)
                ON CONFLICT (slug) DO NOTHING;
            END IF;

            -- Level 3: Women's Clothing
            SELECT id INTO cat_women FROM public.categories WHERE slug = 'womens-clothing';
            IF cat_women IS NOT NULL THEN
                INSERT INTO public.categories (name, slug, parent_id) VALUES
                ('Dresses', 'dresses', cat_women),
                ('Blouses', 'blouses', cat_women),
                ('Skirts', 'skirts', cat_women)
                ON CONFLICT (slug) DO NOTHING;
            END IF;
        END IF;

        -- Level 2: Shoes
        SELECT id INTO cat_shoes FROM public.categories WHERE slug = 'shoes';
        IF cat_shoes IS NOT NULL THEN
             INSERT INTO public.categories (name, slug, parent_id) VALUES
             ('Sneakers', 'sneakers', cat_shoes),
             ('Boots', 'boots', cat_shoes),
             ('Heels', 'heels', cat_shoes)
             ON CONFLICT (slug) DO NOTHING;
        END IF;
    END IF;
END $$;

-- 4. HOME & GARDEN HİYERARŞİSİ
DO $$
DECLARE
    cat_home uuid;
    cat_furn uuid;
    cat_kitchen uuid;
BEGIN
    SELECT id INTO cat_home FROM public.categories WHERE slug = 'home-garden';
    
    IF cat_home IS NOT NULL THEN
        -- Level 1
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Furniture', 'furniture', cat_home),
        ('Kitchen', 'kitchen', cat_home),
        ('Decor', 'decor', cat_home),
        ('Garden', 'garden', cat_home)
        ON CONFLICT (slug) DO NOTHING;

        -- Level 2: Furniture
        SELECT id INTO cat_furn FROM public.categories WHERE slug = 'furniture';
        IF cat_furn IS NOT NULL THEN
             INSERT INTO public.categories (name, slug, parent_id) VALUES
             ('Living Room', 'living-room', cat_furn),
             ('Bedroom', 'bedroom', cat_furn),
             ('Office', 'office-furniture', cat_furn)
             ON CONFLICT (slug) DO NOTHING;
        END IF;

        -- Level 2: Kitchen
        SELECT id INTO cat_kitchen FROM public.categories WHERE slug = 'kitchen';
        IF cat_kitchen IS NOT NULL THEN
             INSERT INTO public.categories (name, slug, parent_id) VALUES
             ('Cookware', 'cookware', cat_kitchen),
             ('Appliances', 'kitchen-appliances', cat_kitchen),
             ('Tableware', 'tableware', cat_kitchen)
             ON CONFLICT (slug) DO NOTHING;
        END IF;
    END IF;
END $$;

-- 5. BEAUTY HİYERARŞİSİ
DO $$
DECLARE
    cat_beauty uuid;
BEGIN
    SELECT id INTO cat_beauty FROM public.categories WHERE slug = 'beauty';
    
    IF cat_beauty IS NOT NULL THEN
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Skincare', 'skincare', cat_beauty),
        ('Makeup', 'makeup', cat_beauty),
        ('Haircare', 'haircare', cat_beauty),
        ('Fragrance', 'fragrance', cat_beauty)
        ON CONFLICT (slug) DO NOTHING;
    END IF;
END $$;

-- 6. SPORTS HİYERARŞİSİ
DO $$
DECLARE
    cat_sports uuid;
BEGIN
    SELECT id INTO cat_sports FROM public.categories WHERE slug = 'sports';
    
    IF cat_sports IS NOT NULL THEN
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Fitness Equipment', 'fitness-equipment', cat_sports),
        ('Outdoor', 'outdoor', cat_sports),
        ('Sportswear', 'sportswear', cat_sports)
        ON CONFLICT (slug) DO NOTHING;
    END IF;
END $$;
