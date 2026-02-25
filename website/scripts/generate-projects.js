#!/usr/bin/env node
/**
 * Generates projects.json from the projects folder by reading each project's pubspec.yaml.
 * Run from website directory: node scripts/generate-projects.js
 */

const fs = require('fs');
const path = require('path');

const PROJECTS_DIR = path.join(__dirname, '../../projects');
const OUTPUT_FILE = path.join(__dirname, '../src/data/projects.json');

// Emoji mapping for project types (folder name -> emoji)
const EMOJI_MAP = {
  components_app: '🎨',
  storybook: '📖',
  api_explorer: '🔌',
  admin_dashboard: '📊',
  storefront_supabase: '🛍️',
  storefront_woo: '🛒',
  sub_serve: '⚡',
  tiny_plates: '🍽️',
};

// Display title overrides (folder name -> display title)
const TITLE_OVERRIDE = {
  storybook: 'Storybook',
  storefront_woo: 'Storefront WooCommerce',
};

// Projects to show "New" badge
const NEW_BADGE_PROJECTS = ['tiny_plates', 'sub_serve'];

// Store links (folder name -> { playStoreUrl?, appStoreUrl?, appStoreMacUrl? })
const STORE_LINKS = {
  storefront_woo: {
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.masterfabric.storefront',
    appStoreUrl: 'https://apps.apple.com/tr/app/masterfabric-store/id6757819630?l=tr',
  },
  storefront_supabase: {
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.masterfabric.storefrontSupabase',
    appStoreUrl: 'https://apps.apple.com/tr/app/masterfabric-s-store/id6758958857?l=tr',
  },
  api_explorer: {
    appStoreMacUrl: 'https://apps.apple.com/tr/app/mf-api-explorer/id6752110806?l=tr&mt=12',
  },
};

function parsePubspec(dirPath) {
  const pubspecPath = path.join(dirPath, 'pubspec.yaml');
  if (!fs.existsSync(pubspecPath)) return null;

  const content = fs.readFileSync(pubspecPath, 'utf-8');
  const nameMatch = content.match(/^name:\s*["']?([^\s"']+)["']?/m);
  const descMatch =
    content.match(/^description:\s*"([^"]*)"/m) ||
    content.match(/^description:\s*'([^']*)'/m) ||
    content.match(/^description:\s*([^\n#]+)/m);

  return {
    name: nameMatch ? nameMatch[1].trim() : path.basename(dirPath),
    description: descMatch
      ? descMatch[1].replace(/\s+/g, ' ').trim()
      : 'Flutter application in the OSMEA ecosystem',
  };
}

function toTitleCase(str) {
  return str
    .split(/[-_]/)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(' ');
}

function generateProjects() {
  if (!fs.existsSync(PROJECTS_DIR)) {
    console.warn(`Projects directory not found: ${PROJECTS_DIR}`);
    fs.writeFileSync(OUTPUT_FILE, JSON.stringify({ items: [] }, null, 2));
    return;
  }

  const dirs = fs.readdirSync(PROJECTS_DIR, { withFileTypes: true });
  const items = [];

  for (const dirent of dirs) {
    if (!dirent.isDirectory()) continue;
    const dirName = dirent.name;
    if (dirName.startsWith('.')) continue;

    const dirPath = path.join(PROJECTS_DIR, dirName);
    const pubspec = parsePubspec(dirPath);
    if (!pubspec) continue;

    const projectId = dirName.replace(/[^a-z0-9]/gi, '-').toLowerCase();
    const title =
      TITLE_OVERRIDE[dirName] ||
      (pubspec.name === dirName ? toTitleCase(dirName) : pubspec.name.replace(/_/g, ' '));

    const item = {
      id: projectId,
      emoji: EMOJI_MAP[dirName] || '📦',
      title: title.replace(/_/g, ' '),
      description: pubspec.description,
      status: 'Completed',
      badgeVariant: 'success',
      path: `projects/${dirName}`,
    };
    const storeLinks = STORE_LINKS[dirName];
    if (storeLinks) {
      if (storeLinks.playStoreUrl) item.playStoreUrl = storeLinks.playStoreUrl;
      if (storeLinks.appStoreUrl) item.appStoreUrl = storeLinks.appStoreUrl;
      if (storeLinks.appStoreMacUrl) item.appStoreMacUrl = storeLinks.appStoreMacUrl;
    }
    if (NEW_BADGE_PROJECTS.includes(dirName)) item.isNew = true;
    items.push(item);
  }

  const output = {
    title: 'OSMEA Projects',
    description: 'Live projects from the workspace – production-ready Flutter applications',
    items: items.sort((a, b) => a.title.localeCompare(b.title)),
  };

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(output, null, 2));
  console.log(`Generated projects.json with ${items.length} projects`);
}

generateProjects();
