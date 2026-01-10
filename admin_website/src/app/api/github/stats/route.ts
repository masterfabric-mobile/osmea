import { NextResponse } from 'next/server';

const GITHUB_REPO = 'masterfabric-mobile/osmea';
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes
let cachedStats: {
  data: unknown;
  timestamp: number;
} | null = null;

export async function GET() {
  try {
    // Check cache
    if (cachedStats && Date.now() - cachedStats.timestamp < CACHE_DURATION) {
      return NextResponse.json(cachedStats.data);
    }

    // Fetch from GitHub API
    const response = await fetch(`https://api.github.com/repos/${GITHUB_REPO}`, {
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'OSMEA-Admin-Panel',
      },
      next: { revalidate: 300 }, // Revalidate every 5 minutes
    });

    if (!response.ok) {
      // Return cached data if available, or fallback
      if (cachedStats) {
        return NextResponse.json(cachedStats.data);
      }
      throw new Error(`GitHub API error: ${response.status}`);
    }

    const repoData = await response.json();

    // Fetch additional stats
    const [contributorsRes, pullsRes] = await Promise.all([
      fetch(`https://api.github.com/repos/${GITHUB_REPO}/contributors?per_page=1&anon=false`, {
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'OSMEA-Admin-Panel',
        },
      }).catch(() => null),
      fetch(`https://api.github.com/repos/${GITHUB_REPO}/pulls?state=open&per_page=1`, {
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'OSMEA-Admin-Panel',
        },
      }).catch(() => null),
    ]);

    // Parse link headers for pagination
    const parseLinkHeader = (header: string | null): number => {
      if (!header) return 0;
      const match = header.match(/page=(\d+)>; rel="last"/);
      return match ? parseInt(match[1]) : 0;
    };

    // Extract stats
    const stats = {
      stars: repoData.stargazers_count || 0,
      forks: repoData.forks_count || 0,
      openIssues: repoData.open_issues_count || 0,
      openPulls: pullsRes?.ok ? parseLinkHeader(pullsRes.headers.get('link')) : 0,
      contributors: contributorsRes?.ok ? parseLinkHeader(contributorsRes.headers.get('link')) || 1 : 0,
      lastCommit: repoData.pushed_at || null,
      license: repoData.license?.name || 'AGPL-3.0',
      language: repoData.language || 'Dart',
      description: repoData.description || '',
      url: repoData.html_url || '',
      createdAt: repoData.created_at || null,
      updatedAt: repoData.updated_at || null,
    };

    // Cache the result
    cachedStats = {
      data: stats,
      timestamp: Date.now(),
    };

    return NextResponse.json(stats);
  } catch (error) {
    console.error('Error fetching GitHub stats:', error);
    
    // Return fallback data
    return NextResponse.json({
      stars: 0,
      forks: 0,
      openIssues: 0,
      openPulls: 0,
      contributors: 0,
      lastCommit: null,
      license: 'AGPL-3.0',
      language: 'Dart',
      description: 'Open Source Mobile E-commerce Architecture',
      url: `https://github.com/${GITHUB_REPO}`,
      createdAt: null,
      updatedAt: null,
    });
  }
}
