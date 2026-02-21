import Link from "next/link";
import { notFound } from "next/navigation";
import { PRIVACY_POLICIES } from "@/data/privacy-policies";
import { ArrowLeft } from "lucide-react";

export async function generateStaticParams() {
  return Object.keys(PRIVACY_POLICIES).map((slug) => ({ slug }));
}

export default async function PrivacyPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const policy = PRIVACY_POLICIES[slug];

  if (!policy) notFound();

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4">
      <div className="container mx-auto max-w-3xl">
        <Link
          href="/"
          className="mb-8 inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to Home
        </Link>

        <header className="mb-12">
          <h1 className="text-3xl font-bold text-gray-900">{policy.title}</h1>
          <p className="mt-2 text-lg text-gray-600">{policy.projectName}</p>
          <p className="mt-1 text-sm text-gray-500">Last updated: {policy.lastUpdated}</p>
        </header>

        <div className="space-y-8 bg-white rounded-xl border border-gray-200 p-8 shadow-sm">
          {policy.sections.map((section, index) => (
            <section key={index}>
              <h2 className="text-xl font-semibold text-gray-900 mb-3">{section.title}</h2>
              <p className="text-gray-600 leading-relaxed">{section.content}</p>
            </section>
          ))}
        </div>
      </div>
    </div>
  );
}
