-- BOOKS HİYERARŞİSİ
DO $$
DECLARE
    cat_books uuid;
BEGIN
    SELECT id INTO cat_books FROM public.categories WHERE slug = 'books';
    
    IF cat_books IS NOT NULL THEN
        -- Level 1: Genres
        INSERT INTO public.categories (name, slug, parent_id) VALUES
        ('Fiction', 'fiction', cat_books),
        ('Non-Fiction', 'non-fiction', cat_books),
        ('Poetry', 'poetry', cat_books),
        ('Children''s Books', 'childrens-books', cat_books)
        ON CONFLICT (slug) DO NOTHING;

        -- Level 2: Fiction Subcategories
        DECLARE
            cat_fiction uuid;
        BEGIN
            SELECT id INTO cat_fiction FROM public.categories WHERE slug = 'fiction';
            IF cat_fiction IS NOT NULL THEN
                INSERT INTO public.categories (name, slug, parent_id) VALUES
                ('Sci-Fi', 'sci-fi', cat_fiction),
                ('Fantasy', 'fantasy', cat_fiction),
                ('Mystery', 'mystery', cat_fiction),
                ('Romance', 'romance', cat_fiction),        -- Aşk Romanları
                ('Thriller', 'thriller', cat_fiction),      -- Gerilim
                ('Horror', 'horror', cat_fiction),          -- Korku
                ('Historical Fiction', 'historical-fiction', cat_fiction), -- Tarihi Roman
                ('Literary Fiction', 'literary-fiction', cat_fiction),     -- Edebi Roman
                ('Classics', 'classics', cat_fiction)       -- Klasikler
                ON CONFLICT (slug) DO NOTHING;
            END IF;
        END;
        
        -- Level 2: Non-Fiction Subcategories
        DECLARE
            cat_nonfiction uuid;
        BEGIN
            SELECT id INTO cat_nonfiction FROM public.categories WHERE slug = 'non-fiction';
            IF cat_nonfiction IS NOT NULL THEN
                INSERT INTO public.categories (name, slug, parent_id) VALUES
                ('Biography', 'biography', cat_nonfiction),
                ('History', 'history', cat_nonfiction),
                ('Science', 'science', cat_nonfiction),
                ('Self-Help', 'self-help', cat_nonfiction),
                ('Business', 'business', cat_nonfiction),
                ('Philosophy', 'philosophy', cat_nonfiction)
                ON CONFLICT (slug) DO NOTHING;
            END IF;
        END;

        -- Level 2: Poetry Subcategories
        DECLARE
            cat_poetry uuid;
        BEGIN
             SELECT id INTO cat_poetry FROM public.categories WHERE slug = 'poetry';
             IF cat_poetry IS NOT NULL THEN
                 INSERT INTO public.categories (name, slug, parent_id) VALUES
                 ('Modern', 'modern-poetry', cat_poetry),
                 ('Classic', 'classic-poetry', cat_poetry),
                 ('Anthologies', 'anthologies', cat_poetry)
                 ON CONFLICT (slug) DO NOTHING;
             END IF;
        END;

    END IF;
END $$;