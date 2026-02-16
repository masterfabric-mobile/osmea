# Smart Child Recipe & Calorie Tracker - Project Analysis

## Project Overview
This project aims to build a mobile application that generates recipes for children based on available home ingredients, age, allergies, and chewing skills. It also includes a daily calorie tracking feature.

## Technical Stack
- **Architecture**: `masterfabric_core: ^0.0.13` (Leveraging `packages/core` structure).
- **UI Components**: `packages/components` (OSMEA Components).
- **Language**: Dart (Flutter).
- **Localization**: `slang` (Multiple languages).
- **Configuration**: `AppConfig` (Dynamic styling & theming, similar to Storefront Woo).
- **Data Source**: Mock Data (Phase 1).
- **Theme**: Minimalist Black & White (Driven by `AppConfig`).

## Timeline
**Duration**: 16 Days

## Daily Breakdown
- **Day 01**: Project Setup, Architecture, `AppConfig` & `Slang` Init (**Including AI/LLM API Endpoint Placeholders**)
- **Day 02**: UI/UX Theming via `AppConfig` & Base Layouts (**`AppConfig` Expanded for Sensory UI**)
- **Day 03**: User Profile Module (Child Details: Age, Allergies, Chewing Skills, **Texture Tolerance, Sensory Preferences, Nutrient Targets**) & **AI-Informed Solids/Texture Guidance**
- **Day 04**: Ingredient Management & Allergy Management Module (**Data Feeds AI for Personalized Filtering & Matching**)
- **Day 05**: **AI-Powered Recipe Engine Logic** (**AI to operate in two modes: 1. Generate recipe from user's ingredients. 2. Proactively recommend a recipe with ideal ingredients based on nutritional gaps.** LLM integration for balancing, substitutions, etc.)
- **Day 06**: Recipe Feed UI (**Displays Rich AI-Adapted Recipes**)
- **Day 07**: Recipe Detail View (**Comprehensive AI-Adapted Recipe Display**: Dynamic Instructions, Sensory Tips, AI Rationale, Detailed Nutrients)
- **Day 08**: **Calorie & Nutrient Tracking Logic** (Comprehensive Tracking of Calories, Macros, Key Micros for Layer 2)
- **Day 09**: Calorie & Nutrient Tracker UI & Growth Tracking (**Visualizes Comprehensive Nutrient Intake; Growth Data Informs AI Analysis**)
- **Day 10**: Search & Filter Functionality (**Natural Language Queries & LLM-Interpretable Filters**)
- **Day 11**: Navigation & Flow Integration (**Ensures Complete Data Flow for AI-Powered Features**)
- **Day 12**: Error Handling & Edge Cases (**Specific Considerations for AI/LLM Interaction Failures & Output Validation**)
- **Day 13**: Quality Assurance & Refinement (**Includes AI Content QA for Safety, Accuracy, and Appropriateness**)
- **Day 14**: Final Review & Delivery (**Focus on Responsible AI Deployment & Ongoing Monitoring**)

## Core Directives

1.  **Use `masterfabric_core`**: Prioritize using existing views (`Splash`, `Onboarding`, `Auth`, `EmptyView`) and utilities.

2.  **Use `osmea_components`**: All UI elements must come from the components package.

3.  **AppConfig Driven**: Colors, styles, and static assets must be loaded from an `AppConfig` JSON, not hardcoded.

4.  **Multilingual**: All text must be localized using `slang`.

5.  **No Dynamic Pages**: Page layouts are static; only their content/style is configurable.

6.  **Strict Architecture**: All Views MUST extend `MasterViewHydratedCubit`. All ViewModels MUST extend `BaseViewModelHydratedCubit`. This ensures consistent state persistence and lifecycle management across the entire app.

## Kullanıcı Deneyimi (UX) Stratejisi ve Ana Akışlar (Rev. 2)
Uygulamanın temel amacı, ebeveynler için hem pratik bir "kurtarıcı" hem de proaktif bir "dijital diyetisyen" olmaktır. Bu iki rol, hibrit bir modelde birleşir.

### Ana Senaryo 1: "Dolabımda Ne Var?" (Kurtarıcı Asistan)
- **Problem:** Ebeveynin kısıtlı zamanda, evdeki mevcut malzemelerle ne yapacağını bilememesi.
- **Çözüm:** Kullanıcı, elindeki malzemeleri seçer. AI, bu malzemelere, çocuğun profiline (yaş, alerji vb.) ve güvenlik kurallarına (`Safety Guardrail`) uygun bir tarif üretir.
- **Uygulama Rolü:** Anlık ihtiyacı pratik bir şekilde çözen asistan. Bu, en sık kullanılacak özelliktir.

### Ana Senaryo 2: "Bugün Ne Yemeli?" (Dijital Diyetisyen)
- **Problem:** Çocuğun günlük besin ihtiyaçlarının (kalori, protein, vitamin vb.) dengeli bir şekilde karşılandığından emin olmak.
- **Çözüm:** Sistem, gün içinde girilen verilere dayanarak çocuğun besin eksikliklerini tespit eder (Örn: "Bugün hiç protein almadı ve C vitamini eksik"). Bu eksiklikleri giderecek ideal malzemelerle proaktif olarak bir tarif önerir.
- **Uygulama Rolü:** Ebeveyne yol gösteren, çocuğun gelişimini destekleyen uzman. Bu, uygulamanın "akıllı" ve prestijli yönüdür.

### Hibrit Model Akışı
1.  **Öneri Ekranı (Varsayılan):** Uygulama açıldığında, kullanıcıyı proaktif öneri ekranı (`Senaryo 2`) karşılar.
2.  **Malzeme Kontrolü:** Eğer kullanıcı önerilen tarifi yapmak için yeterli malzemeye sahip değilse, tek bir dokunuşla malzeme seçme ekranına (`Senaryo 1`) geçer.
3.  **Akıllı Eşleşme:** Kullanıcı malzeme seçimi yaparken, sistem seçilen malzemelerin besin değerleri hakkında anlık geri bildirimler sunar (Örn: "Bu malzeme günlük demir ihtiyacının %50'sini karşılar.").

## Geliştirme Notları ve İyileştirme Alanları (Rev. 1)

Aşağıdaki maddeler, mevcut plana ek olarak projenin güvenliğini ve işlevselliğini artırmak için eklenecektir.

### 1. "3 Gün Kuralı" İzleme Mantığı
- **Gereksinim:** Ek gıdaya geçiş dönemindeki (6+ ay) bebekler için "yeni gıda tanıştırma protokolü" uygulanmalıdır.
- **Detay:** Kullanıcı bir gıdayı "yeni" olarak işaretlediğinde, sistem bu gıdayı 3 gün boyunca "takip moduna" almalıdır.
- **Kısıtlama:** Bu 3 günlük takip süresince, sistem başka **yeni** bir gıda içeren tarif önermemelidir. Bu özellik, potansiyel alerjik reaksiyonların kaynağını net bir şekilde belirlemeye yardımcı olur.
- **Entegrasyon:** Bu mantık, `Ingredient Management` ve `AI-Powered Recipe Engine` modüllerine entegre edilmelidir.

### 2. AI "Safety Guardrail" (Güvenlik Katmanı)
- **Gereksinim:** AI tarafından üretilen tariflerin bebek sağlığı için risk oluşturmadığından emin olunmalıdır. AI halüsinasyonları hayati riskler taşıyabilir (Örn: 1 yaşından küçük bebeğe bal önermesi).
- **Detay:** AI'dan bir tarif yanıtı alındığında, bu tarif kullanıcıya gösterilmeden hemen önce **Hard-coded bir Validation Layer (Doğrulama Katmanı)** tarafından kontrol edilmelidir.
- **Kısıtlama:** Bu katman, çocuğun yaşına göre kesinlikle yasak olan gıdaların bir listesini içermelidir (Örn: Bal, tuz, şeker, işlenmiş gıdalar, boğulma riski taşıyan kuruyemişler vb.). Yasaklı bir içerik tespit edilirse, tarif kullanıcıya gösterilmemeli ve alternatif bir tarif sunulmalıdır.
- **Entegrasyon:** Bu kontrol, `AI-Powered Recipe Engine Logic` ve `Recipe Feed UI` arasındaki akışa eklenmelidir.

### 3. Veri Senkronizasyonu ve "Partial Intake" (Kısmi Alım)
- **Gereksinim:** Kalori ve besin takibinin doğruluğu için, çocuğun bir öğünün ne kadarını tükettiği bilgisi kaydedilebilmelidir.
- **Detay:** Kullanıcı, hazırlanan bir tarifin "tamamını", "yarısını", "çeyreğini" yediği gibi seçenekleri işaretleyebilmelidir.
- **Kısıtlama:** Sistem, girilen bu orana göre kalori ve makro/mikro besin değerlerini otomatik olarak hesaplayıp günlüğe kaydetmelidir.
- **Entegrasyon:** Bu özellik, `Calorie & Nutrient Tracking Logic` ve `Calorie & Nutrient Tracker UI` modüllerine eklenmelidir.