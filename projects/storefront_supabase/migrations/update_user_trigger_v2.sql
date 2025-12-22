-- 1. Tabloya username kolonunu ekle (Eğer henüz eklemediyseniz)
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username text;

-- 2. Trigger fonksiyonunu güncelle
-- Bu fonksiyon, auth.users tablosuna yeni kayıt eklendiğinde çalışır
-- ve public.users tablosuna veriyi kopyalar.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url, username)
  VALUES (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url',
    new.raw_user_meta_data->>'username' -- Username bilgisini metadata'dan al
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Trigger'ın tanımlı olduğundan emin olun (Genelde kurulumda yapılır ama kontrol etmekte fayda var)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
