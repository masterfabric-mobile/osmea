import { Shield, Code, Users, Zap, Terminal } from "lucide-react";

export default function RulesClaimsSection() {
  return (
    <section className="py-12 px-4 bg-white border-t border-gray-100">
      <div className="max-w-3xl mx-auto text-center mb-10">
        <h2 className="text-2xl font-semibold text-gray-900 mb-4">Why Do We Use Rules?</h2>
        <p className="text-gray-600 mb-6">
          To ensure code quality, security, and smooth collaboration, we maintain a set of clear rules and standards for all contributors.
        </p>
      </div>
      <div className="max-w-5xl mx-auto flex flex-col items-center gap-4 sm:grid sm:grid-cols-2 sm:gap-6 lg:flex lg:flex-row lg:justify-center lg:items-stretch lg:gap-6 mb-10">
        {/* Security */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 sm:p-5 flex flex-col items-center text-center shadow-sm w-full max-w-xs lg:max-w-[200px]">
          <div className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-blue-100 mb-2 sm:mb-3">
            <Shield className="w-4 h-4 sm:w-5 sm:h-5 text-blue-600" />
          </div>
          <h3 className="font-medium text-gray-900 mb-1 text-sm sm:text-base">Security</h3>
          <p className="text-xs sm:text-sm text-gray-600">Standards for API security, data protection, and safe coding practices.</p>
        </div>
        {/* Code Quality */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 sm:p-5 flex flex-col items-center text-center shadow-sm w-full max-w-xs lg:max-w-[200px]">
          <div className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-green-100 mb-2 sm:mb-3">
            <Code className="w-4 h-4 sm:w-5 sm:h-5 text-green-600" />
          </div>
          <h3 className="font-medium text-gray-900 mb-1 text-sm sm:text-base">Code Quality</h3>
          <p className="text-xs sm:text-sm text-gray-600">Consistent style, performance optimization, and maintainable architecture.</p>
        </div>
        {/* Collaboration */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 sm:p-5 flex flex-col items-center text-center shadow-sm w-full max-w-xs lg:max-w-[200px]">
          <div className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-purple-100 mb-2 sm:mb-3">
            <Users className="w-4 h-4 sm:w-5 sm:h-5 text-purple-600" />
          </div>
          <h3 className="font-medium text-gray-900 mb-1 text-sm sm:text-base">Collaboration</h3>
          <p className="text-xs sm:text-sm text-gray-600">Teamwork, code review processes, and documentation standards.</p>
        </div>
        {/* Efficiency */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 sm:p-5 flex flex-col items-center text-center shadow-sm w-full max-w-xs lg:max-w-[200px]">
          <div className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-orange-100 mb-2 sm:mb-3">
            <Zap className="w-4 h-4 sm:w-5 sm:h-5 text-orange-600" />
          </div>
          <h3 className="font-medium text-gray-900 mb-1 text-sm sm:text-base">Efficiency</h3>
          <p className="text-xs sm:text-sm text-gray-600">Automated checks that speed up development and prevent errors.</p>
        </div>
        {/* IDE Recommendation */}
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 sm:p-5 flex flex-col items-center text-center shadow-sm w-full max-w-xs lg:max-w-[200px]">
          <div className="flex items-center justify-center w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-gray-100 mb-2 sm:mb-3">
            <Terminal className="w-4 h-4 sm:w-5 sm:h-5 text-gray-500" />
          </div>
          <h3 className="font-medium text-gray-900 mb-1 text-sm sm:text-base">IDE Recommendation</h3>
          <p className="text-xs sm:text-sm text-gray-600">We recommend <span className="font-medium text-gray-800">Cursor</span> or <span className="font-medium text-gray-800">VSCode</span> for the best experience and compliance.</p>
        </div>
      </div>

      {/* IDE Experiences Section */}
      <div className="max-w-4xl mx-auto mb-10">
        <h3 className="text-xl font-semibold text-gray-900 text-center mb-6">Our IDE Experience</h3>
        <div className="flex flex-col sm:flex-row gap-6 justify-center">
          {/* Cursor Experience */}
          <a 
            href="https://cursor.com" 
            target="_blank" 
            rel="noopener noreferrer"
            className="bg-white rounded-lg p-6 shadow-sm flex flex-col items-center text-center max-w-sm hover:shadow-md transition-shadow cursor-pointer"
          >
            <div className="flex items-center justify-center w-12 h-12 rounded-full bg-gray-100 mb-4">
              <img 
                src="https://cursor.com/assets/images/logo.svg" 
                alt="Cursor Logo" 
                className="w-8 h-8"
              />
            </div>
            <h4 className="font-semibold text-gray-900 mb-2">Cursor</h4>
            <p className="text-sm text-gray-600 mb-3">
              AI-powered code editor with advanced features for faster development and intelligent code completion.
            </p>
            <div className="flex flex-wrap gap-2 justify-center">
              <span className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded">AI Assistant</span>
              <span className="px-2 py-1 bg-green-100 text-green-800 text-xs rounded">Fast</span>
              <span className="px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded">Modern</span>
            </div>
          </a>

          {/* VSCode Experience */}
          <a 
            href="https://code.visualstudio.com" 
            target="_blank" 
            rel="noopener noreferrer"
            className="bg-white rounded-lg p-6 shadow-sm flex flex-col items-center text-center max-w-sm hover:shadow-md transition-shadow cursor-pointer"
          >
            <div className="flex items-center justify-center w-12 h-12 rounded-full bg-gray-100 mb-4">
              <img 
                src="https://code.visualstudio.com/assets/branding/code-stable.png" 
                alt="Visual Studio Code Logo" 
                className="w-8 h-8"
              />
            </div>
            <h4 className="font-semibold text-gray-900 mb-2">Visual Studio Code</h4>
            <p className="text-sm text-gray-600 mb-3">
              Lightweight, powerful code editor with extensive extensions and excellent Flutter/Dart support.
            </p>
            <div className="flex flex-wrap gap-2 justify-center">
              <span className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded">Extensible</span>
              <span className="px-2 py-1 bg-green-100 text-green-800 text-xs rounded">Stable</span>
              <span className="px-2 py-1 bg-orange-100 text-orange-800 text-xs rounded">Popular</span>
            </div>
          </a>
        </div>
      </div>

      <div className="text-center">
        <a
          href="https://github.com/masterfabric-mobile/osmea/tree/dev/rules"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-2 border border-gray-300 px-5 py-2 rounded-md text-sm text-gray-800 hover:bg-gray-50 transition-colors font-medium"
        >
          View Rules
          <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" /></svg>
        </a>
      </div>
    </section>
  );
} 