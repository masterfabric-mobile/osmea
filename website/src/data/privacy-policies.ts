export const PRIVACY_POLICIES: Record<
  string,
  { title: string; projectName: string; lastUpdated: string; sections: { title: string; content: string }[] }
> = {
  "storefront-woo": {
    title: "Privacy Policy",
    projectName: "MasterFabric Store (WooCommerce)",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Information We Collect",
        content:
          "We collect information you provide directly, such as when you create an account, place an order, or contact us. This may include your name, email address, shipping address, payment information, and phone number.",
      },
      {
        title: "How We Use Your Information",
        content:
          "We use the information we collect to process orders, provide customer support, send order updates, improve our services, and comply with legal obligations. We do not sell your personal information to third parties.",
      },
      {
        title: "Data Security",
        content:
          "We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.",
      },
      {
        title: "Contact Us",
        content:
          "If you have questions about this Privacy Policy, please contact us at support@masterfabric.co.",
      },
    ],
  },
  "storefront-supabase": {
    title: "Privacy Policy",
    projectName: "MasterFabric S Store (Supabase)",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Information We Collect",
        content:
          "We collect information you provide when using our app, including account details, order information, and preferences. Data is stored securely using Supabase infrastructure.",
      },
      {
        title: "How We Use Your Information",
        content:
          "Your information is used to process orders, authenticate users, and improve the shopping experience. We may use analytics to understand app usage and performance.",
      },
      {
        title: "Data Retention",
        content:
          "We retain your data only as long as necessary to fulfill the purposes for which it was collected or as required by law.",
      },
      {
        title: "Contact Us",
        content:
          "For privacy-related inquiries, please reach out to support@masterfabric.co.",
      },
    ],
  },
  "api-explorer": {
    title: "Privacy Policy",
    projectName: "MF API Explorer",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Information We Collect",
        content:
          "MF API Explorer stores API configuration data locally on your device. We do not collect or transmit personal data to our servers. Credentials and API keys are stored in your local SQLite database.",
      },
      {
        title: "Local Data",
        content:
          "All data entered in the app, including store URLs, API keys, and configuration details, remains on your device. We do not have access to this information.",
      },
      {
        title: "Third-Party Services",
        content:
          "When you connect to Shopify or WooCommerce APIs, your requests go directly to those services. Please refer to their respective privacy policies for how they handle your data.",
      },
      {
        title: "Contact Us",
        content:
          "Questions about this Privacy Policy can be sent to support@masterfabric.co.",
      },
    ],
  },
  "components-app": {
    title: "Privacy Policy",
    projectName: "Components App",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Overview",
        content:
          "Components App is a showcase application for OSMEA UI components. We do not collect personal data through this application.",
      },
      {
        title: "Contact",
        content: "For inquiries, contact support@masterfabric.co.",
      },
    ],
  },
  "storybook": {
    title: "Privacy Policy",
    projectName: "Storybook",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Overview",
        content:
          "OSMEA Storybook is a documentation and development tool. No personal data is collected.",
      },
      {
        title: "Contact",
        content: "For inquiries, contact support@masterfabric.co.",
      },
    ],
  },
  "admin-dashboard": {
    title: "Privacy Policy",
    projectName: "Admin Dashboard",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Overview",
        content:
          "The Admin Dashboard is an e-commerce management tool. Admin users' data is processed in accordance with applicable data protection laws.",
      },
      {
        title: "Contact",
        content: "For privacy inquiries, contact support@masterfabric.co.",
      },
    ],
  },
  "sub-serve": {
    title: "Privacy Policy",
    projectName: "Sub Serve",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Overview",
        content:
          "Sub Serve collects and processes data as necessary to provide its services. We do not sell your information to third parties.",
      },
      {
        title: "Contact",
        content: "For questions, contact support@masterfabric.co.",
      },
    ],
  },
  "tiny-plates": {
    title: "Privacy Policy",
    projectName: "Tiny Plates",
    lastUpdated: "2025-02-21",
    sections: [
      {
        title: "Overview",
        content:
          "Tiny Plates processes user data to deliver its functionality. Your data is handled securely and in compliance with applicable regulations.",
      },
      {
        title: "Contact",
        content: "For privacy-related requests, contact support@masterfabric.co.",
      },
    ],
  },
};
