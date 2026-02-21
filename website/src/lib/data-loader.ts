import heroData from '@/data/hero.json';
import featuresData from '@/data/features.json';
import progressData from '@/data/progress.json';
import projectsData from '@/data/projects.json';
import footerData from '@/data/footer.json';
import siteConfig from '@/data/site-config.json';

export const data = {
  hero: heroData,
  features: featuresData,
  progress: { ...progressData, projects: projectsData },
  footer: footerData,
  siteConfig: siteConfig,
};

export type HeroData = typeof heroData;
export type FeaturesData = typeof featuresData;
export type ProgressData = typeof progressData;
export type FooterData = typeof footerData;
export type SiteConfig = typeof siteConfig; 