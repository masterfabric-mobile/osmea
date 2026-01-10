import { HeroSection } from '@/components/landing/hero-section';
import { FeaturesGrid } from '@/components/landing/features-grid';
import { ProjectInfo, Footer } from '@/components/landing/project-info';

export default function LandingPage() {
  return (
    <main className="min-h-screen">
      <HeroSection />
      <FeaturesGrid />
      <ProjectInfo />
      <Footer />
    </main>
  );
}
