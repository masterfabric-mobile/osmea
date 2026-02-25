'use client';

import { useEffect } from 'react';
import Link from 'next/link';
import { X, FileText, ArrowUpRight } from 'lucide-react';

interface ProjectItem {
  id: string;
  title: string;
  emoji: string;
}

interface DocumentationModalProps {
  isOpen: boolean;
  onClose: () => void;
  projects: ProjectItem[];
}

export default function DocumentationModal({ isOpen, onClose, projects }: DocumentationModalProps) {
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      document.body.style.overflow = 'hidden';
    }
    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.body.style.overflow = '';
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm"
      onClick={onClose}
    >
      <div
        className="relative w-full max-w-lg rounded-2xl border border-gray-200/80 bg-white p-6 shadow-2xl"
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
          <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-gray-100">
            <FileText className="h-6 w-6 text-gray-600" strokeWidth={2} />
          </div>
          <div>
            <h3 className="text-xl font-bold tracking-tight text-gray-900">Documentation</h3>
            <p className="text-sm text-gray-500">Privacy policies by project</p>
          </div>
        </div>

        <div className="space-y-2 max-h-[60vh] overflow-y-auto">
          {projects.map((project) => (
            <Link
              key={project.id}
              href={`/privacy/${project.id}`}
              onClick={onClose}
              className="flex items-center gap-3 rounded-xl border border-gray-200/80 bg-white p-4 transition-all hover:border-gray-300 hover:shadow-md hover:-translate-y-0.5"
            >
              <span className="text-2xl">{project.emoji}</span>
              <span className="flex-1 font-medium text-gray-900">{project.title}</span>
              <span className="text-sm text-gray-500">Privacy Policy</span>
              <ArrowUpRight className="h-4 w-4 text-gray-400" strokeWidth={2} />
            </Link>
          ))}
        </div>

        <p className="mt-4 text-xs text-gray-500">
          Each project has its own privacy policy. Click to view on a dedicated page.
        </p>
      </div>
    </div>
  );
}
