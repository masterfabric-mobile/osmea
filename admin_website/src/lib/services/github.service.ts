export interface GitHubStats {
  stars: number;
  forks: number;
  openIssues: number;
  openPulls: number;
  contributors: number;
  lastCommit: string | null;
  license: string;
  language: string;
  description: string;
  url: string;
  createdAt: string | null;
  updatedAt: string | null;
}

export class GitHubService {
  private static cache: {
    data: GitHubStats | null;
    timestamp: number;
  } = {
    data: null,
    timestamp: 0,
  };

  private static CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

  static async getStats(): Promise<GitHubStats> {
    // Check cache
    if (
      this.cache.data &&
      Date.now() - this.cache.timestamp < this.CACHE_DURATION
    ) {
      return this.cache.data;
    }

    try {
      const response = await fetch('/api/github/stats', {
        next: { revalidate: 300 },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch GitHub stats');
      }

      const data = await response.json();
      
      this.cache = {
        data,
        timestamp: Date.now(),
      };

      return data;
    } catch (error) {
      console.error('Error fetching GitHub stats:', error);
      
      // Return fallback
      return {
        stars: 0,
        forks: 0,
        openIssues: 0,
        openPulls: 0,
        contributors: 0,
        lastCommit: null,
        license: 'AGPL-3.0',
        language: 'Dart',
        description: 'Open Source Mobile E-commerce Architecture',
        url: 'https://github.com/masterfabric-mobile/osmea',
        createdAt: null,
        updatedAt: null,
      };
    }
  }

  static formatDate(dateString: string | null): string {
    if (!dateString) return 'Unknown';
    
    try {
      const date = new Date(dateString);
      const now = new Date();
      const diffMs = now.getTime() - date.getTime();
      const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
      
      if (diffDays === 0) return 'Today';
      if (diffDays === 1) return 'Yesterday';
      if (diffDays < 7) return `${diffDays} days ago`;
      if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`;
      if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`;
      return `${Math.floor(diffDays / 365)} years ago`;
    } catch {
      return 'Unknown';
    }
  }
}
