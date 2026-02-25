'use client';

import { useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Github, ExternalLink, CheckCircle, Circle, Clock, X, ArrowUpRight, Play, Apple, Monitor, FolderGit2 } from "lucide-react";

interface ProgressCard {
  id: string;
  title: string;
  emoji: string;
  description: string;
  status: string;
  badgeText: string;
  badgeVariant: string;
}

interface Component {
  name: string;
  status: string;
}

interface StatusDefinition {
  status: string;
  title: string;
  description: string;
  color: string;
}

interface Package {
  id: string;
  emoji: string;
  title: string;
  description: string;
  status: string;
  badgeVariant: string;
  githubUrl: string;
}

interface ProjectItem {
  id: string;
  emoji: string;
  title: string;
  description: string;
  status: string;
  badgeVariant: string;
  path: string;
  isNew?: boolean;
  playStoreUrl?: string;
  appStoreUrl?: string;
  appStoreMacUrl?: string;
}

interface ProgressData {
  title: string;
  overallProgress: number;
  progressCards: ProgressCard[];
  projects?: {
    title: string;
    description?: string;
    items: ProjectItem[];
  };
  coreComponents: {
    title: string;
    components: Component[];
  };
  layoutUtilities: {
    title: string;
    components: Component[];
  };
  statusDefinitions: {
    title: string;
    definitions: StatusDefinition[];
  };
  packages: {
    title: string;
    packages: Package[];
  };
}

interface ProgressSectionProps {
  data: ProgressData;
}

function StatusIcon({ status }: { status: string }) {
  switch (status) {
    case "completed":
      return <CheckCircle className="w-4 h-4 text-green-500" />;
    case "in-progress":
      return <Clock className="w-4 h-4 text-yellow-500" />;
    case "not-started":
      return <Circle className="w-4 h-4 text-gray-400" />;
    default:
      return <Circle className="w-4 h-4 text-gray-400" />;
  }
}

const GITHUB_BASE = "https://github.com/masterfabric-mobile/osmea/tree/dev";

const StoreLinkCard = ({
  href,
  icon: Icon,
  label,
  sublabel,
  accentClass,
}: {
  href: string;
  icon: React.ElementType;
  label: string;
  sublabel?: string;
  accentClass: string;
}) => (
  <a
    href={href}
    target="_blank"
    rel="noopener noreferrer"
    className={`group flex items-center gap-4 rounded-xl border border-gray-200/80 bg-white p-4 transition-all duration-200 hover:border-gray-300 hover:shadow-md hover:-translate-y-0.5 ${accentClass}`}
  >
    <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-lg bg-gray-100 text-gray-600 group-hover:bg-gray-200">
      <Icon className="h-5 w-5" strokeWidth={2} />
    </div>
    <div className="min-w-0 flex-1 text-left">
      <span className="block font-semibold text-gray-900">{label}</span>
      {sublabel && <span className="text-xs text-gray-500">{sublabel}</span>}
    </div>
    <ArrowUpRight className="h-4 w-4 shrink-0 text-gray-400 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5 group-hover:text-gray-600" strokeWidth={2} />
  </a>
);

function ProjectDetailsModal({
  project,
  onClose,
}: {
  project: ProjectItem;
  onClose: () => void;
}) {
  const hasStoreLinks = project.playStoreUrl || project.appStoreUrl || project.appStoreMacUrl;
  const repoUrl = `${GITHUB_BASE}/${project.path}`;

  if (!hasStoreLinks) {
    return (
      <div
        className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm transition-opacity"
        onClick={onClose}
      >
        <div className="transition-transform">
          <div
            className="relative w-full max-w-md rounded-2xl border border-gray-200/80 bg-white p-6 shadow-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              onClick={onClose}
              className="absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-lg text-gray-400 transition-colors hover:bg-gray-100 hover:text-gray-600"
              aria-label="Close"
            >
              <X className="h-5 w-5" strokeWidth={2} />
            </button>
            <div className="flex items-center gap-3 pb-4">
              <span className="flex h-12 w-12 items-center justify-center rounded-xl bg-gray-100 text-2xl">
                {project.emoji}
              </span>
              <div>
                <h3 className="text-xl font-bold tracking-tight text-gray-900">{project.title}</h3>
                <p className="text-sm text-gray-500">View source code</p>
              </div>
            </div>
            <p className="text-sm text-gray-600">
              This project is not yet available on app stores. Open the repository to explore the source code.
            </p>
            <div className="mt-6 flex gap-3">
              <Button variant="outline" onClick={onClose} className="flex-1">
                Cancel
              </Button>
              <a
                href={repoUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex flex-1 items-center justify-center gap-2 rounded-lg bg-gray-900 px-4 py-2.5 text-sm font-medium text-white transition-colors hover:bg-gray-800"
              >
                <FolderGit2 className="h-4 w-4" strokeWidth={2} />
                Open Repository
                <ArrowUpRight className="h-3.5 w-3.5" strokeWidth={2} />
              </a>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm transition-opacity"
      onClick={onClose}
    >
      <div className="w-full max-w-md transition-transform">
        <div
          className="relative rounded-2xl border border-gray-200/80 bg-white shadow-2xl"
          onClick={(e) => e.stopPropagation()}
        >
          <button
            onClick={onClose}
            className="absolute right-4 top-4 z-10 flex h-8 w-8 items-center justify-center rounded-lg text-gray-400 transition-colors hover:bg-gray-100 hover:text-gray-600"
            aria-label="Close"
          >
            <X className="h-5 w-5" strokeWidth={2} />
          </button>
          <div className="p-6 pt-8">
            <div className="flex items-center gap-3">
              <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-gray-100 text-2xl">
                {project.emoji}
              </span>
              <div className="min-w-0">
                <h3 className="text-xl font-bold tracking-tight text-gray-900">{project.title}</h3>
                <p className="text-sm text-gray-500">Download from app stores</p>
              </div>
            </div>
            <div className="mt-6 space-y-3">
              {project.playStoreUrl && (
                <StoreLinkCard
                  href={project.playStoreUrl}
                  icon={Play}
                  label="Google Play"
                  sublabel="Android"
                  accentClass="hover:border-emerald-200 hover:bg-emerald-50/50"
                />
              )}
              {project.appStoreUrl && (
                <StoreLinkCard
                  href={project.appStoreUrl}
                  icon={Apple}
                  label="App Store"
                  sublabel="iPhone & iPad"
                  accentClass="hover:border-slate-300 hover:bg-slate-50/50"
                />
              )}
              {project.appStoreMacUrl && (
                <StoreLinkCard
                  href={project.appStoreMacUrl}
                  icon={Monitor}
                  label="Mac App Store"
                  sublabel="macOS"
                  accentClass="hover:border-slate-300 hover:bg-slate-50/50"
                />
              )}
            </div>
            <a
              href={repoUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-4 flex w-full items-center justify-center gap-2 rounded-lg border border-gray-200 py-2.5 text-sm font-medium text-gray-600 transition-colors hover:border-gray-300 hover:bg-gray-50"
            >
              <Github className="h-4 w-4" strokeWidth={2} />
              View on GitHub
              <ArrowUpRight className="h-3.5 w-3.5" strokeWidth={2} />
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}

function ComponentGrid({ components }: { components: Component[] }) {
  return (
    <div className="grid md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
      {components.map((component) => (
        <div 
          key={component.name} 
          className="flex items-center justify-between p-3 bg-white rounded-lg border hover:shadow-sm transition-shadow"
        >
          <span className="font-medium text-sm">{component.name}</span>
          <StatusIcon status={component.status} />
        </div>
      ))}
    </div>
  );
}

export default function ProgressSection({ data }: ProgressSectionProps) {
  const [detailsProject, setDetailsProject] = useState<ProjectItem | null>(null);

  return (
    <section className="py-20 px-4 bg-gray-50">
      <div className="container mx-auto max-w-6xl">
        <div className="text-center space-y-4 mb-16">
          <h2 className="text-4xl font-bold text-gray-900">{data.title}</h2>
          <p className="text-xl text-gray-600">
            Overall Progress: <strong>{data.overallProgress}%</strong> Complete
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {data.progressCards.map((card) => (
            <Card key={card.id} className="text-center">
              <CardHeader>
                <CardTitle className="text-lg">{card.title}</CardTitle>
                <div className="text-3xl font-bold text-green-600">{card.emoji}</div>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-gray-600">{card.description}</p>
                <Badge variant={card.badgeVariant as "default" | "secondary" | "destructive" | "outline" | "success" | "warning"} className="mt-2">
                  {card.badgeText}
                </Badge>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Core Components Status, Layout Utilities, Status Definitions - hidden for now
        <div className="mt-16">
          <h3 className="text-2xl font-bold text-center mb-8">
            {data.coreComponents.title}
          </h3>
          <ComponentGrid components={data.coreComponents.components} />
          <div className="mt-8 flex justify-center gap-8">
            <div className="flex items-center gap-2">
              <CheckCircle className="w-4 h-4 text-green-500" />
              <span className="text-sm text-gray-600">Completed</span>
            </div>
            <div className="flex items-center gap-2">
              <Clock className="w-4 h-4 text-yellow-500" />
              <span className="text-sm text-gray-600">In Progress</span>
            </div>
            <div className="flex items-center gap-2">
              <Circle className="w-4 h-4 text-gray-400" />
              <span className="text-sm text-gray-600">Not Started</span>
            </div>
          </div>
          <div className="mt-16">
            <h3 className="text-2xl font-bold text-center mb-8">
              {data.layoutUtilities.title}
            </h3>
            <ComponentGrid components={data.layoutUtilities.components} />
            <div className="mt-8 bg-gray-50 rounded-lg p-6">
              <h4 className="text-lg font-semibold mb-4 text-center">
                {data.statusDefinitions.title}
              </h4>
              <div className="grid md:grid-cols-3 gap-4">
                {data.statusDefinitions.definitions.map((definition) => (
                  <div key={definition.status} className="flex items-start gap-3">
                    <StatusIcon status={definition.status} />
                    <div>
                      <span className={`font-medium text-${definition.color}-700`}>
                        {definition.title}
                      </span>
                      <p className="text-sm text-gray-600 mt-1">
                        {definition.description}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
        */}

        {/* Packages Section */}
          <div className="mt-16">
            <h3 className="text-2xl font-bold text-center mb-8">
              {data.packages.title}
            </h3>
            <div className="grid md:grid-cols-3 gap-6">
              {data.packages.packages.map((pkg) => (
                <Card key={pkg.id} className="text-center">
                  <CardHeader>
                    <div className="text-4xl mb-4">{pkg.emoji}</div>
                    <CardTitle className="text-xl">{pkg.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-sm text-gray-600 mb-4">
                      {pkg.description}
                    </p>
                    <div className="space-y-2">
                      <Badge variant={pkg.badgeVariant as "default" | "secondary" | "destructive" | "outline" | "success" | "warning"}>
                        {pkg.status}
                      </Badge>
                      <div>
                        <Button variant="outline" size="sm" asChild>
                          <Link 
                            href={pkg.githubUrl} 
                            target="_blank" 
                            className="flex items-center gap-2"
                          >
                            <Github className="w-3 h-3" />
                            View Source
                            <ExternalLink className="w-3 h-3" />
                          </Link>
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Projects Section */}
          {data.projects && (
            <div className="mt-16">
              <h3 className="text-2xl font-bold text-center mb-4">
                {data.projects.title}
              </h3>
              {data.projects.description && (
                <p className="text-center text-gray-600 mb-8 max-w-2xl mx-auto">
                  {data.projects.description}
                </p>
              )}
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                {data.projects.items.map((project) => (
                  <Card key={project.id} className="text-center relative overflow-visible">
                    {project.isNew && (
                      <Badge className="absolute -top-2 right-3 bg-green-500 hover:bg-green-600 text-white border-0 text-xs font-semibold px-2 py-0.5">
                        New
                      </Badge>
                    )}
                    <CardHeader>
                      <div className="text-4xl mb-4">{project.emoji}</div>
                      <CardTitle className="text-lg">{project.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <p className="text-sm text-gray-600 mb-4">
                        {project.description}
                      </p>
                      <div className="mt-3 flex flex-col gap-2">
                        <Button
                          size="sm"
                          onClick={() => setDetailsProject(project)}
                          className="w-full gap-2"
                        >
                          Project Details
                        </Button>
                        <Button variant="outline" size="sm" asChild>
                          <Link
                            href={`${GITHUB_BASE}/${project.path}`}
                            target="_blank"
                            className="flex items-center justify-center gap-2"
                          >
                            <Github className="w-3 h-3" />
                            Source
                            <ExternalLink className="w-3 h-3" />
                          </Link>
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>
          )}
      </div>
      {detailsProject && (
        <ProjectDetailsModal
          project={detailsProject}
          onClose={() => setDetailsProject(null)}
        />
      )}
    </section>
  );
} 