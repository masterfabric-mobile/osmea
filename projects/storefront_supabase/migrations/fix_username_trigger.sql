-- 1. Tabloya username kolonunu güvenli bir şekilde ekle
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username text;

-- 2. Trigger fonksiyonunu güncelle (Çakışma önleyici ON CONFLICT eklendi)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url, username)
  VALUES (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    new.raw_user_meta_data->>'username'
  )
  ON CONFLICT (id) DO UPDATE
  SET
    -- Eğer kayıt zaten varsa (çakışma durumunda) username ve diğer alanları güncelle
    username = EXCLUDED.username,
    full_name = COALESCE(EXCLUDED.full_name, public.users.full_name),
    email = EXCLUDED.email,
    avatar_url = COALESCE(EXCLUDED.avatar_url, public.users.avatar_url),
    updated_at = now();
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Trigger'ın varlığından emin ol (Yoksa oluştur, varsa elleme)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created') THEN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
  END IF;
END
$$;
