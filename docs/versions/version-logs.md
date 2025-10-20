# 📦 OSMEA Packages Version Changelog

> This changelog is generated from the latest closed pull requests. For a full, always-up-to-date changelog, visit [Closed PRs on GitHub](https://github.com/masterfabric-mobile/osmea/pulls?q=is%3Apr+is%3Aclosed).  

## 📦 APIs – v0.48.11

- **[#226 – Package → API → Woocommerce Checkout Checkout Order and Order API](https://github.com/masterfabric-mobile/osmea/pull/226)**  
  Adds checkout, order creation, order retrieval, payment, and related handlers/models for WooCommerce Store API. Completes core transactional flow.

- **[#225 – Package → API → Woocommerce Product Brand Attribute Attribute Term API](https://github.com/masterfabric-mobile/osmea/pull/225)**  
  Adds support for Product Brands, Attributes, and Attribute Terms to the API layer, including models, handlers, DI, and UI integration.

- **[#224 – Package → API → Woocommerce Product Reviews Collection Data Category Tags API](https://github.com/masterfabric-mobile/osmea/pull/224)**  
  Adds support for WooCommerce Product Tags, Reviews, Collections, and Categories APIs, with services, models, registry, and UI-side support.

- **[#223 – Package → API → Woocommerce Product API](https://github.com/masterfabric-mobile/osmea/pull/223)**  
  Implements WooCommerce Store API Product and Product Variations endpoints, including services, models, DI, filtering, and cleanup.

- **[#218 – Package → API → Woocommerce Cart Items API](https://github.com/masterfabric-mobile/osmea/pull/218)**  
  Adds full CRUD support for WooCommerce Store API Cart Items (models, handlers, DI registration).

- **[#206 – Package → API → Woocommerce Wishlist](https://github.com/masterfabric-mobile/osmea/pull/206)**  
  Integrates WooCommerce Wishlist API, CRUD operations, group and item management, Admin/Customer API separation, models and services.

- **[#203 – Package → API → Woocommerce Update Password Module](https://github.com/masterfabric-mobile/osmea/pull/203)**  
  Adds secure password update feature to the WooCommerce auth module, new endpoint, validation, StoreSetupWizard UI integration.

- **[#195 – Package → API → Woocommerce Delete Account Module](https://github.com/masterfabric-mobile/osmea/pull/195)**  
  Adds Delete User API with JWT and Auth Key, UI integration, secure account deletion.

- **[#190 – Package → API → Woocommerce Sign Up Module](https://github.com/masterfabric-mobile/osmea/pull/190)**  
  Extends WooCommerce auth with authKey support for secure, store-scoped signup flow. Model, service, and UI refactors.

- **[#189 – Package → API → Woocommerce Auth Module](https://github.com/masterfabric-mobile/osmea/pull/189)**  
  Adds JWT-based WooCommerce authentication layer, models, services, local storage persistence, session handling and UI improvements.

- **[#169 – Api Explorer – Searchbar in ModernSidebar](https://github.com/masterfabric-mobile/osmea/pull/169)**  
  Adds search functionality to ModernSidebar for dynamic API filtering, case-insensitive, real-time updates for improved navigation.

- **[#149 – Apis - Refactor and Improvement GraphQL Structure](https://github.com/masterfabric-mobile/osmea/pull/149)**  
  Introduced a modern GraphQL architecture, migrated from REST to GraphQL, established an annotation-driven, type-safe client and service structure.

- **[#141 – Package – API → Add Shop Wizard and Sample Code](https://github.com/masterfabric-mobile/osmea/pull/141)**  
  Added wizard-based configuration for WooCommerce/Shopify, improved the API Explorer, introduced new UI panels, and refactored store management logic.  
  _Reason_: New features and core improvements, suitable for a minor version bump.

- **[#140 – OSMEA - Api - Example → Moving and Renaming](https://github.com/masterfabric-mobile/osmea/pull/140)**  
  Moved and renamed the `example` directory to `projects/api_explorer`, enhancing project structure and maintainability.

- **[#136 – OSMEA - Fix → WooCommerce API Batch Registry](https://github.com/masterfabric-mobile/osmea/pull/136)**  
  Bug fixes, minor optimizations, and code improvements for the WooCommerce batch API registry and services.

- **[#126 – OSMEA - Package - API → Network woocommerce patch operations](https://github.com/masterfabric-mobile/osmea/pull/126)**  
  Added batch update operations for multiple WooCommerce resources (products, categories, attributes, reviews, shipping methods, tax rates, webhooks) through new handlers and registry integration.

- **[#124 – OSMEA - Package - API → Network woocommerce patch operations](https://github.com/masterfabric-mobile/osmea/pull/124)**  
  Introduced batch update functionality for WooCommerce Coupons, Customers, and Orders via new API handlers and service registry updates.

- **[#123 – OSMEA - Package - Docs → woocommerce config pop and sidebar menu](https://github.com/masterfabric-mobile/osmea/pull/123)**  
  Standardized ApiServiceRegistry category/subcategory naming and added WooCommerce-specific configuration fields to the config popup.

- **[#122 – OSMEA - Package - API → Network woocommerce shipping zone](https://github.com/masterfabric-mobile/osmea/pull/122)**  
  Integrated WooCommerce Shipping Zones and Shipping Zone Methods APIs, including CRUD services, handlers, and new UI elements for zone management.

- **[#120 – Network woocommerce taxes](https://github.com/masterfabric-mobile/osmea/pull/120)**  
  Full WooCommerce Taxes API integration (Tax Classes & Tax Rates), with new handlers, services, models, and registry updates.

- **[#115 – WooCommerce Reports & Settings API Integration](https://github.com/masterfabric-mobile/osmea/pull/115)**  
  Full integration and UI categories for WooCommerce Reports and Settings APIs, including new handlers and registry updates.

- **[#114 – WooCommerce Shipping Methods & Payment Gateways API Integration](https://github.com/masterfabric-mobile/osmea/pull/114)**  
  Added new APIs and handlers for shipping methods and payment gateways, with sidebar UI extensions.

- **[#111 – WooCommerce Webhooks & System Status API Integration](https://github.com/masterfabric-mobile/osmea/pull/111)**  
  Integrated WooCommerce Webhooks and System Status APIs, added new sidebar navigation categories and icons. Significant feature expansion.

- **[#110 – WooCommerce Product Management API Integration](https://github.com/masterfabric-mobile/osmea/pull/110)**  
  Implemented full CRUD support for products, categories, tags, attributes, shipping classes, and reviews. Major feature set and architectural enhancement.

- **[#109 – WooCommerce Orders & Order Notes API Integration](https://github.com/masterfabric-mobile/osmea/pull/109)**  
  Added complete backend support for WooCommerce Orders and Order Notes with new service clients, handlers, and registry bindings.

- **[#107 – Network WooCommerce Customers](https://github.com/masterfabric-mobile/osmea/pull/107)**  
  Integrated full WooCommerce Customers API (CRUD), including models, services, handlers, and UI management. Major infrastructure addition.

- **[#106 – Network WooCommerce Coupons](https://github.com/masterfabric-mobile/osmea/pull/106)**  
  Developed full CRUD implementation for WooCommerce Coupon API, including models, services, handlers, and UI management. Significant infrastructure feature.

- **[#104 – Divide File Structure Shopify and WooCommerce](https://github.com/masterfabric-mobile/osmea/pull/104)**  
  Refactored and restructured handler and network layers, separated Shopify and WooCommerce modules. Substantial architectural and infrastructure improvement.

- **[#101 – Sidebar Category Management Refactor](https://github.com/masterfabric-mobile/osmea/pull/101)**  
  Refactored category structures and improved modularity for Shopify/WooCommerce APIs. Code improvements without breaking changes.

- **[#97 – WooCommerce Integration and Coupons](https://github.com/masterfabric-mobile/osmea/pull/97)**  
  Introduced a multi-platform coupon management system for WooCommerce, added new service logic, and extended API capabilities. Major new package feature.

- **[#59 – Example App: Drawer, Overflow, Config Reminder, URL Copy Fix](https://github.com/masterfabric-mobile/osmea/pull/59)**  
  Refactored sidebar into a drawer, fixed overflow issues, added a one-time configuration reminder popup, and fixed the copy URL button.

- **[#31 – Code Standardization](https://github.com/masterfabric-mobile/osmea/pull/31)**  
  Standardized parameter naming (using `model`), unified service and handler interfaces, improved logging and documentation throughout API services.

- **[#30 – API Explorer UI Revamp & Dark Mode](https://github.com/masterfabric-mobile/osmea/pull/30)**  
  Comprehensive UI overhaul for API Explorer, including dark mode, responsive design, visual enhancements, and code quality improvements.

- **[#29 – DraftOrder Handler Import Path Fix](https://github.com/masterfabric-mobile/osmea/pull/29)**  
  Fixed incorrect import path for DraftOrderService to align with the updated file structure. No changes to logic.

- **[#28 – Discount, Order, Refund Service Refactor](https://github.com/masterfabric-mobile/osmea/pull/28)**  
  Refactored folder and file names, updated import statements, and improved code style and structure.

- **[#27 – Billing, TenderTransaction, Webhook Service Refactor](https://github.com/masterfabric-mobile/osmea/pull/27)**  
  Consolidated service classes, unified interfaces, updated dependency injection, and ensured naming consistency.

- **[#26 – Gift Card & Event API Fixes](https://github.com/masterfabric-mobile/osmea/pull/26)**  
  Critical fixes for Gift Card and Event APIs, including initial value parsing, request body corrections, new response models, and improved filtering.

- **[#25 – Product Image API Handlers](https://github.com/masterfabric-mobile/osmea/pull/25)**  
  Added lifecycle handlers for product images covering creation, retrieval, modification, and deletion. Built with extensible and modular architecture.

- **[#24 – Product Variant API Handlers](https://github.com/masterfabric-mobile/osmea/pull/24)**  
  Implemented complete CRUD operations, management, image and metafield handlers for product variants, with validation and consistent API patterns.

- **[#23 – Order API Full Documentation & Handlers](https://github.com/masterfabric-mobile/osmea/pull/23)**  
  Provided structured documentation and full lifecycle handlers for Orders, Draft Orders, Risks, Refunds, Transactions, and metadata.

- **[#22 – Custom Collection & Product API Handlers](https://github.com/masterfabric-mobile/osmea/pull/22)**  
  Developed comprehensive CRUD and specialized handlers for Custom Collection and Product categories, including error management and service integration.

- **[#21 – Collect API Full Implementation](https://github.com/masterfabric-mobile/osmea/pull/21)**  
  Added complete Collect service and handlers, advanced filtering, unified architecture, error handling, and improved categorization.

- **[#20 – Product Collections API Integration](https://github.com/masterfabric-mobile/osmea/pull/20)**  
  Introduced new collection services and handlers for fetching product collections and their details. Included abstracted service, modular handlers, and Freezed models.

- **[#19 – Smart Collections API Implementation](https://github.com/masterfabric-mobile/osmea/pull/19)**  
  Implemented full-featured Smart Collection APIs: CRUD operations, product ordering, advanced filtering, modular handlers, dependency injection, and robust error handling.

- **[#17 – Marketing Event API Implementation](https://github.com/masterfabric-mobile/osmea/pull/17)**  
  Added REST APIs for marketing event creation, management, retrieval, and engagement. Enhanced validation, error handling, UI updates, and documentation.

- **[#16 – Webhooks API Integration](https://github.com/masterfabric-mobile/osmea/pull/16)**  
  Implemented full Webhooks API support including listing, retrieval, counting, creation, update, and deletion. Added robust filtering, error handling, and a new API category.

- **[#15 – Online Store REST API Test Coverage](https://github.com/masterfabric-mobile/osmea/pull/15)**  
  Introduced extensive test coverage and CRUD handlers for Articles, Blogs, Pages, Comments, Assets, Redirects, ScriptTags, and Themes. Modular, metadata-aware, validated structure.

- **[#14 – Tender Transaction API Support](https://github.com/masterfabric-mobile/osmea/pull/14)**  
  Added TenderTransaction model and API handler. Supports all query parameters (limit, order, processed_at, since_id), proper error handling, and documentation.

- **[#13 – Shopify Billing API Integration](https://github.com/masterfabric-mobile/osmea/pull/13)**  
  Implemented all Shopify Billing flows: one-time charges, recurring charges, credits, and usage charges. Full API coverage, robust error handling, and comprehensive documentation.

- **[#12 – Network Store Properties API](https://github.com/masterfabric-mobile/osmea/pull/12)**  
  Added comprehensive Shopify store properties APIs for Countries, Provinces, Shipping Zones, and Shop Configuration. Modular, type-safe handlers, improved filtering, and extensibility.

- **[#11 – Text Standardisation & Typo Fixes](https://github.com/masterfabric-mobile/osmea/pull/11)**  
  Refactored text and comments across handlers, improved error messages, unified terminology, and fixed typos.

- **[#10 – Metafield Update & Delete Fixes](https://github.com/masterfabric-mobile/osmea/pull/10)**  
  Improved metafield update and delete logic, added validation and error handling for robust editing and removal across resources.

- **[#9 – Metafield CRUD Handlers](https://github.com/masterfabric-mobile/osmea/pull/9)**  
  Introduced comprehensive metafield handlers for full create, read, update, and delete operations across all resource types, including advanced query capabilities.

- **[#8 – Gift Card API Integration](https://github.com/masterfabric-mobile/osmea/pull/8)**  
  Added full Shopify Gift Card API support, including creation, disabling, updating, advanced listing, search, and a modular handler architecture.

- **[#5 – Discount & Price Rule API](https://github.com/masterfabric-mobile/osmea/pull/5)**  
  Implemented full Discount Code and Price Rule REST API functionality, with CRUD handlers, input validation, standardized error handling, and documentation.

- **[#3 – Inventory API Expansion](https://github.com/masterfabric-mobile/osmea/pull/3)**  
  Comprehensive Inventory API update with new handlers for items, levels, and locations; extended error handling, parameter validation, and response consistency.

- **[#2 – Shopify Events API Integration](https://github.com/masterfabric-mobile/osmea/pull/2)**  
  Added full Shopify Events API support including list, single, and count endpoints; modular request handling, robust error reporting, and edge case validation.

- **[#1 – Network Customers API Integration](https://github.com/masterfabric-mobile/osmea/pull/1)**  
  Major improvements to customer management: new API endpoints, enhanced validation, search and filtering, pagination fixes, UI enhancements, and updated documentation.


## 🎨 Components – v0.67.25

- **[#229 – Components → Component and Styling Improvements](https://github.com/masterfabric-mobile/osmea/pull/229)**  
  Enhances OsmeaChips, IconButton, ImageCard, and other UI components with new shape, style, icon, and customization options.

- **[#222 – Components → Appbar With Searchbar and Improvements Components App](https://github.com/masterfabric-mobile/osmea/pull/222)**  
  Adds AppBar with integrated search bar, suggestions/history, action buttons, layout and SafeArea improvements, and utility extensions.

- **[#221 – Components → ImageCard and Carousel Improvement](https://github.com/masterfabric-mobile/osmea/pull/221)**  
  Adds text overflow control, padding options to card components, customizable dot indicators for carousel, and visual flexibility.

- **[#217 – Components → Phone Picker](https://github.com/masterfabric-mobile/osmea/pull/217)**  
  Adds Phone Picker component to UI Kit, supports country code/flag, validation, customizability, and callback integration.

- **[#168 – Storybook – Wrap Component](https://github.com/masterfabric-mobile/osmea/pull/168)**  
  Adds Storybook for Wrap component, modular architecture, flexible layout, alignment/direction/spacing controls, dynamic child management, and responsive design.

- **[#167 – Storybook – Tab Bars Component](https://github.com/masterfabric-mobile/osmea/pull/167)**  
  Adds Storybook for TabBar component, modular architecture, multiple variants, interactive showcase, indicator options, centralized knob config, and dynamic tab management.

- **[#166 – Storybook – Column and Spacer Components](https://github.com/masterfabric-mobile/osmea/pull/166)**  
  Adds Storybook for Column & Spacer components, featuring vertical layouts, adaptive sizing, alignment/indicator controls, flexible spacing, and responsive previews.

- **[#163 – Storybook – Toast Component](https://github.com/masterfabric-mobile/osmea/pull/163)**  
  Added a Storybook showcase for the Toast component, featuring interactive demonstration, style/type/position/animation controls, stacking behavior, and configuration display.

- **[#162 – Storybook – SizedBox Component](https://github.com/masterfabric-mobile/osmea/pull/162)**  
  Developed Storybook for the SizedBox component, including fixed dimensions, interactive sliders, grid/dimension overlays, child variants, live preview, and documentation.

- **[#161 – Storybook – Row Component](https://github.com/masterfabric-mobile/osmea/pull/161)**  
  Implemented Storybook for the Row component, providing flexible horizontal layout, alignment, spacing, sizing, child management, live preview, and a properties panel.

- **[#160 – Storybook – RichText Component](https://github.com/masterfabric-mobile/osmea/pull/160)**  
  Created Storybook for the RichText component, supporting inline styling, typography variants, layout/overflow settings, accessibility, live preview, and documentation.

- **[#159 – Storybook – Padding Component](https://github.com/masterfabric-mobile/osmea/pull/159)**  
  Introduced Storybook for the Padding component, with flexible spacing controls, live slider adjustments, support for various child types, and documentation.

- **[#158 – Storybook – ClipRRect Component](https://github.com/masterfabric-mobile/osmea/pull/158)**  
  Adds Storybook for ClipRRect component with rounded corner clipping, customizable border radius, clip behavior, child variants, and responsive design.

- **[#157 – Storybook – Align Component](https://github.com/masterfabric-mobile/osmea/pull/157)**  
  Provided a Storybook for the Align component, enabling precise alignment control and support for multiple child types.

- **[#156 – Storybook – Stack Component](https://github.com/masterfabric-mobile/osmea/pull/156)**  
  Added a Storybook showcase for the Stack component, including alignment, fit, clip behavior, multi-child support, modular architecture, and live preview.

- **[#155 – Storybook – Snackbar Component](https://github.com/masterfabric-mobile/osmea/pull/155)**  
  Developed a full Storybook showcase for the Snackbar component with device frames, position logic, progress animations, stacking, and type color support.

- **[#154 – Storybook – Image Component](https://github.com/masterfabric-mobile/osmea/pull/154)**  
  Added a comprehensive and modular Storybook showcase for Image components, including interactive controls, multiple variants, flexible sizing, advanced configuration, and improved error handling.

- **[#152 – Storybook – Collapse Component](https://github.com/masterfabric-mobile/osmea/pull/152)**  
  Created an interactive Storybook showcase for the Collapse component, including both Collapse and Accordion modes.

- **[#151 – Storybook – Dropdown Component](https://github.com/masterfabric-mobile/osmea/pull/151)**  
  Introduced a comprehensive Storybook showcase for the Dropdown component, with support for multiple variants.

- **[#150 – Storybook – Home Page UI Improvements](https://github.com/masterfabric-mobile/osmea/pull/150)**  
  Improved the Storybook home page UI with modern card designs, a compact layout, and enhanced visual hierarchy.

- **[#148 – Storybook – Stepper Component](https://github.com/masterfabric-mobile/osmea/pull/148)**  
  Added a fully interactive Stepper component and related showcase to Storybook.

- **[#147 – Storybook – Popup Component](https://github.com/masterfabric-mobile/osmea/pull/147)**  
  Introduced a modular Storybook Popup component with interactive feature showcase and real-time configuration options.

- **[#146 – Storybook – Refactor](https://github.com/masterfabric-mobile/osmea/pull/146)**  
  Unified imports, performed code cleanup, improved registry, and enhanced export management for Storybook components.

- **[#145 – Storybook – BottomSheet Component](https://github.com/masterfabric-mobile/osmea/pull/145)**  
  Added an interactive Storybook for the BottomSheet component, featuring variant showcase, native-like behavior, and live configuration controls.

- **[#132 – Storybook File Renaming](https://github.com/masterfabric-mobile/osmea/pull/132)**  
  Renamed all Storybook component files for consistent naming; updated imports, with no functional changes.

- **[#130 – OSMEA - Components - Storybook → Ticket](https://github.com/masterfabric-mobile/osmea/pull/130)**  
  Implemented a modular, interactive Storybook for the Ticket Widget, featuring live controls for all field types, styling options, and detailed documentation.

- **[#129 – OSMEA - Fix → Project Admin Dashboard](https://github.com/masterfabric-mobile/osmea/pull/129)**  
  Made structural improvements, refactors, and bug fixes to the Admin Dashboard and Onboarding modules, including navigation updates, event handling, and UI consistency.

- **[#128 – OSMEA - Components - Storybook → Searchbar](https://github.com/masterfabric-mobile/osmea/pull/128)**  
  Added an interactive Storybook showcase for the Searchbar component, supporting multiple variants, live knob controls, and style previews.

- **[#127 – OSMEA - Components - Storybook → Carousel](https://github.com/masterfabric-mobile/osmea/pull/127)**  
  Developed a comprehensive, interactive Storybook showcase for the Carousel component, featuring all variants, real-time configuration, and documentation.

- **[#125 – OSMEA - Projects → Admin Dashboard - Onboarding View](https://github.com/masterfabric-mobile/osmea/pull/125)**  
  Implemented an onboarding view for the admin dashboard, introducing a responsive, multi-step onboarding UI with improved navigation and error handling; no breaking changes.

- **[#118 – Components Storybook → Footer](https://github.com/masterfabric-mobile/osmea/pull/118)**  
  Created an interactive Storybook for the Footer component, including all variants, live knobs, documentation, modular structure, and UI enhancements.

- **[#117 – Network WooCommerce Data and Refund](https://github.com/masterfabric-mobile/osmea/pull/117)**  
  Integrated WooCommerce continents, countries, currencies, and refunds API; introduced global ApiDataService, sidebar category icons, and new handlers.

- **[#116 – Components Storybook → Typography](https://github.com/masterfabric-mobile/osmea/pull/116)**  
  Added a comprehensive Typography documentation page for Storybook, featuring a clean layout and variant showcase; no breaking changes.

- **[#113 – Components Storybook Color Page Finalization](https://github.com/masterfabric-mobile/osmea/pull/113)**  
  Finalized comprehensive showcase and documentation for all color palettes in the Design System, enhancing UI documentation.

- **[#108 – Container Storybook Component](https://github.com/masterfabric-mobile/osmea/pull/108)**  
  Created a comprehensive Storybook showcase for Container widgets, with interactive UI additions. Component and documentation enhancements; no breaking changes.

- **[#105 – Counter + Chips Integration Bug Fix](https://github.com/masterfabric-mobile/osmea/pull/105)**  
  Fixed a critical integration issue between Counter and Chips widgets, ensuring state and layout consistency.

- **[#103 – Counter Storybook Component](https://github.com/masterfabric-mobile/osmea/pull/103)**  
  Added new variants and customization options for the Counter component, integrated with Storybook. Included enhancements and UI improvements, with no structural changes.

- **[#102 – List Item Storybook Component](https://github.com/masterfabric-mobile/osmea/pull/102)**  
  Developed a comprehensive Storybook showcase for List Item variants, improving UI/UX with no breaking changes.

- **[#98 – Divider Storybook Component](https://github.com/masterfabric-mobile/osmea/pull/98)**  
  Added an interactive showcase for the Divider component, fixed rendering bugs, and introduced UI improvements.

- **[#94 – Text Component Storybook](https://github.com/masterfabric-mobile/osmea/pull/94)**  
  Added a modular Storybook for the OsmeaText component, featuring interactive documentation for variants, size, color, alignment, and decoration options.

- **[#93 – Progress Indicators Storybook](https://github.com/masterfabric-mobile/osmea/pull/93)**  
  Developed a modular and interactive Storybook for circular and linear progress indicators, including knobs for type, size, value, and display configuration.

- **[#92 – Loading Animations Storybook](https://github.com/masterfabric-mobile/osmea/pull/92)**  
  Added a comprehensive modular showcase for loading animations, with interactive controls for type, size, and color selection.

- **[#91 – Dot Indicator Component Extensions](https://github.com/masterfabric-mobile/osmea/pull/91)**  
  Introduced a full set of extensions for the DotIndicator component, enabling customization of size, variant, position, style, shape, and animation for flexible UI integration.

- **[#88 – Snackbar Component with Progress Bar](https://github.com/masterfabric-mobile/osmea/pull/88)**  
  Added an advanced Snackbar system supporting stacking, positioning, animated progress bars, swipe-to-dismiss, action and close buttons, and maximum stack limit.

- **[#87 – Collapse Component Refactor (Cubit Architecture)](https://github.com/masterfabric-mobile/osmea/pull/87)**  
  Refactored the OsmeaCollapse component to use Cubit-based state management, modularized the collapse panel and item, added support for all variants and styles, and aligned with the design system.

- **[#86 – Const, Deprecated Update, Bug Fix](https://github.com/masterfabric-mobile/osmea/pull/86)**  
  Added `const` keywords throughout the app, updated deprecated methods, fixed major bugs, and removed unnecessary web folder.

- **[#85 – Counter Component & Extensions](https://github.com/masterfabric-mobile/osmea/pull/85)**  
  Introduced a fully modular, theme-aware Counter component with extensions for size, icon, layout, state, value, and animation, enabling scalable UI usage.

- **[#84 – Typography & Component Standardization](https://github.com/masterfabric-mobile/osmea/pull/84)**  
  Modernized examples with OsmeaTextStyle and OsmeaComponents, simplified file names and code structure.

- **[#83 – Storybook Component Registry Standardization](https://github.com/masterfabric-mobile/osmea/pull/83)**  
  Centralized registration of Storybook components, reduced duplication, and improved maintainability.

- **[#82 – Imports & Opacity Fixes](https://github.com/masterfabric-mobile/osmea/pull/82)**  
  Removed unused imports, fixed color opacity warnings, and cleaned up the codebase.

- **[#81 – Example Refactor: OsmeaComponents & Colors](https://github.com/masterfabric-mobile/osmea/pull/81)**  
  Updated all example widgets to use OsmeaComponents and OsmeaColors, cleaned up legacy layout code.

- **[#80 – Storybook Modular Chips Showcase](https://github.com/masterfabric-mobile/osmea/pull/80)**  
  Added a modular Storybook showcase for chips, featuring style, state, size, color knobs, closeable/avatar/icon chips, and interactive single/multi selection demos.

- **[#79 – Footer Component](https://github.com/masterfabric-mobile/osmea/pull/79)**  
  Introduced OsmeaFooter: a responsive, customizable, and accessible footer component featuring a divider, layout variants, and up to three interactive items.

- **[#78 – Stateless Image Component Refactor](https://github.com/masterfabric-mobile/osmea/pull/78)**  
  Refactored OsmeaImage from a StatefulWidget to a StatelessWidget, removing animation logic for improved performance and maintainability.

- **[#77 – Cubit-Based Dropdown Component](https://github.com/masterfabric-mobile/osmea/pull/77)**  
  Added a new OsmeaDropdown system with Cubit state management, avatar/integrated item types, validation, custom builders, and comprehensive theme/token support.

- **[#76 – Storybook Modular Cards Showcase](https://github.com/masterfabric-mobile/osmea/pull/76)**  
  Implemented a fully modular Storybook for Cards, providing interactive knob controls, variants, sizes, image positioning, badge overlays, and responsive design.

- **[#75 – TabBar Enum System](https://github.com/masterfabric-mobile/osmea/pull/75)**  
  Introduced enums for TabBar size, variant, position, style, tab state, and indicator style to support scalable, system-wide tab configuration.

- **[#74 – Storybook Modular Badge Showcase](https://github.com/masterfabric-mobile/osmea/pull/74)**  
  Added a unified, modular badge Storybook with live knob controls for badge size, variant, style, state, shape, and position, plus an interactive demo of all badge features.

- **[#70 – Advanced SearchBar Component](https://github.com/masterfabric-mobile/osmea/pull/70)**  
  Developed a highly customizable search bar supporting multiple variants and styles, suggestions, history, debounce, accessibility, and loading/error states.

- **[#69 – Docs & Typo Improvements](https://github.com/masterfabric-mobile/osmea/pull/69)**  
  Improved comments, checklist clarity, and documentation traceability for UI system components.

- **[#68 – Toast Message System](https://github.com/masterfabric-mobile/osmea/pull/68)**  
  Introduced an enum-based toast notification system with support for type, style, animation, position, stacked display, and accessibility.

- **[#67 – FittedBox & ClipRRect Primitives](https://github.com/masterfabric-mobile/osmea/pull/67)**  
  Added OsmeaComponents.fittedBox and OsmeaComponents.clipRRect primitives, including theme support and example screens.

- **[#66 – Example Refactor: Unified OsmeaComponents Usage](https://github.com/masterfabric-mobile/osmea/pull/66)**  
  Refactored all UI examples to use OsmeaComponents, unified styling and layout, removed unused widgets/imports, and improved maintainability.

- **[#65 – Modular Avatar Storybook](https://github.com/masterfabric-mobile/osmea/pull/65)**  
  Created an interactive Avatar showcase in Storybook with real-time knob controls for all features (size, appearance, image/text/icon/content, border, elevation) and a modular code structure.

- **[#63 – Components Storybook Application](https://github.com/masterfabric-mobile/osmea/pull/63)**  
  Added a comprehensive Storybook environment for the OSMEA UI Kit, including interactive documentation, device frame testing, modular template system, live knob controls, and centralized theming.

- **[#60 – Divider Component System](https://github.com/masterfabric-mobile/osmea/pull/60)**  
  Developed a powerful, multi-variant divider component supporting classic, dashed, dotted, gradient, double, fade, icon, label, zigzag, wave, angled, and vertical styles, with direction, theming, and accessibility support.

- **[#58 – Progress & Stepper Enum System](https://github.com/masterfabric-mobile/osmea/pull/58)**  
  Unified enums for progress and stepper components, including types for progress bars (linear, circular, segmented), sizes, and step status states.

- **[#57 – Core Layout & Rich Text Primitives](https://github.com/masterfabric-mobile/osmea/pull/57)**  
  Added OsmeaStack, Flexible, Spacer, Positioned, RichText, and TextSpan primitives; all abstracted into the core architecture with full theming support.

- **[#56 – Stepper Component System](https://github.com/masterfabric-mobile/osmea/pull/56)**  
  Introduced a feature-rich, customizable, and responsive stepper component with BLoC state management, multiple visual styles, async validation, and color system integration.

- **[#55 – Loading Component Enum System](https://github.com/masterfabric-mobile/osmea/pull/55)**  
  Added enum-based configuration for loading indicators, with dozens of animation types, size scaling, and design system integration.

- **[#54 – Example Improvements: ActionCard & Form](https://github.com/masterfabric-mobile/osmea/pull/54)**  
  Improved OsmeaActionCard layout, added text color contrast utilities, enhanced dropdown field reliability, and improved code formatting.

- **[#53 – Card & Avatar Components](https://github.com/masterfabric-mobile/osmea/pull/53)**  
  Added OsmeaCard (basic, image, action) and OsmeaAvatar components with full support for theming, sizes, appearances, image positions, actions, and fallback logic.

- **[#52 – List Item Component Enum System](https://github.com/masterfabric-mobile/osmea/pull/52)**  
  Developed an extensive enum system for OsmeaListItem, supporting variants, size, selection, trailing types, platform, border sides, and more for highly flexible list UI design.

- **[#51 – Carousel Component Architecture](https://github.com/masterfabric-mobile/osmea/pull/51)**  
  Implemented a fully customizable, enum-driven, and Cubit-powered carousel system, including new enums for size, variant, navigation, autoplay, transition, indicator, arrows, and more.

- **[#50 – Chips Component Enum System](https://github.com/masterfabric-mobile/osmea/pull/50)**  
  Added a complete enum architecture for chips, covering size, variant, style, shape, and state, enhancing modularity and consistency for chip components.
                                    
- **[#48 – Badge Component Enum System](https://github.com/masterfabric-mobile/osmea/pull/48)**  
  Added full enum support for badges, covering size, variant, state, position, shape, and style. Unified badge configuration across all usages for consistency and modularity.

- **[#47 – TextField & OTP Field System](https://github.com/masterfabric-mobile/osmea/pull/47)**  
  Introduced a modular text field and OTP field system featuring enums, advanced Cubit/controller layers, and comprehensive widget demos.

- **[#46 – Mobile Demo: Wrap, Scaffold, ScrollView](https://github.com/masterfabric-mobile/osmea/pull/46)**  
  Added `OsmeaWrap`, `OsmeaScaffold`, and `OsmeaSingleChildScrollView` components, with mobile demo screens for foundational layout and navigation.

- **[#45 – Core Layout Components](https://github.com/masterfabric-mobile/osmea/pull/45)**  
  Abstracted and refactored all layout primitives (`Align`, `Center`, `Column`, `Row`, `Expanded`, `Padding`, `SizedBox`) using core inheritance and design token principles.

- **[#44 – OsmeaContainer Component](https://github.com/masterfabric-mobile/osmea/pull/44)**  
  Added a highly customizable container component with full decoration, gesture, and layout control.

- **[#43 – OsmeaAppBar Component System](https://github.com/masterfabric-mobile/osmea/pull/43)**  
  Introduced a modular, enum-driven AppBar architecture; added variants, behaviors, styles, and refactored all AppBar logic for extensibility and customization.

- **[#42 – Navbar & Button Enhancement](https://github.com/masterfabric-mobile/osmea/pull/42)**  
  Added shape variants to `OsmeaButton`, updated `OsmeaNavbar` alignment, and improved overall layout consistency.

- **[#41 – Extensions & Text Components Overhaul](https://github.com/masterfabric-mobile/osmea/pull/41)**  
  Major update to sizer, text, theme, input, and system extensions. Refactored all components for unified styling, typography, and responsive logic.

- **[#40 – Remove Neumorphism from Switch](https://github.com/masterfabric-mobile/osmea/pull/40)**  
  Removed the `neumorphism` style from OsmeaSwitch enums and documentation due to redundancy and accessibility concerns.

- **[#39 – OsmeaRadio Button Component](https://github.com/masterfabric-mobile/osmea/pull/39)**  
  Added a fully customizable radio button component with scalable enum architecture, style, interaction states, accessibility, and flexible grouping.

- **[#38 – OsmeaCheckbox Component](https://github.com/masterfabric-mobile/osmea/pull/38)**  
  Developed a feature-rich customizable checkbox component supporting size, variant, style, state, label position, and design tokens, with export registration.

- **[#36 – Modular Navbar System](https://github.com/masterfabric-mobile/osmea/pull/36)**  
  Added OsmeaNavbar with style variants, sizing, positioning, interactive item states, and responsive/adaptive layout for advanced navigation.

- **[#35 – OsmeaSwitch / Switch Button Components](https://github.com/masterfabric-mobile/osmea/pull/35)**  
  Built highly customizable switch/toggle components with enums for size, style, label position, color variant, and responsive design.

- **[#34 – Cubit Button & Auth Integration](https://github.com/masterfabric-mobile/osmea/pull/34)**  
  Introduced a modular button system with bloc/cubit state management for async/auth flows, including OsmeaLoginButton, state classes, and AuthService integration.

- **[#33 – OsmeaButton System](https://github.com/masterfabric-mobile/osmea/pull/33)**  
  Created a flexible, theme-aware button architecture: core, text, and icon buttons with variants, states, sizing, icon logic, and accessibility features.

- **[#32 – Core UI Component Architecture](https://github.com/masterfabric-mobile/osmea/pull/32)**  
  Established a modular, scalable UI structure (`lib/src/`), reusable components, enums, design tokens, and core infrastructure for future UI elements.
                                           

## ⚙️ Core – v3.20.4

- **[#227 – Core → Loading/Error Views and State Management Improvements](https://github.com/masterfabric-mobile/osmea/pull/227)**  
  Adds LoadingViewCubit, ErrorHandlingCubit, new loading/error widgets with styles, and centralizes asynchronous state handling.

- **[#219 – Core → WebViewerHelper Integration](https://github.com/masterfabric-mobile/osmea/pull/219)**  
  Adds a unified helper for HTML/WebView rendering, OSMEA-styled widgets, auto-detection logic, and secure HTML sanitization.

- **[#214 – Core → MasterScaffoldWidget](https://github.com/masterfabric-mobile/osmea/pull/214)**  
  Introduces MasterScaffoldWidget for unified flexible layout in MasterView ecosystem, with no breaking changes; enhances configuration and maintainability.

- **[#212 – Core → Hydrated Cubit](https://github.com/masterfabric-mobile/osmea/pull/212)**  
  Adds hydrated_bloc, hydrated base classes for cubits, enables persisted state management across app restarts, aligns dependencies, and enhances developer experience.

- **[#211 – Core → BaseView & ViewModel Cubit Refactor](https://github.com/masterfabric-mobile/osmea/pull/211)**  
  Refactors BaseViewCubit, BaseViewModelCubit, and related classes for simplification and clarity; renames typedefs and improves maintainability.

- **[#207 – Core → Permission Handler Helper Improvements](https://github.com/masterfabric-mobile/osmea/pull/207)**  
  Adds enhanced permission handling (Android 12+ exact alarm permission), intelligent caching, robust error handling, cross-platform support, and production-ready architecture.

- **[#207 – Core → Permission Handler Helper Improvements](https://github.com/masterfabric-mobile/osmea/pull/207)**  
    Adds exact alarm permission management for Android 12+, intelligent permission caching, cross-platform permission handling, advanced error handling, smart storage permission management, real-time permission status tracking, and production-ready architecture.

- **[#204 – Core → Master-View-Cubit](https://github.com/masterfabric-mobile/osmea/pull/204)**  
  Small improvement in KeyboardTypeExtension (update to TextInputType) and MasterViewCubit export path update.

- **[#202 – Core → File Download Helper & Update → Components App](https://github.com/masterfabric-mobile/osmea/pull/202)**  
  Enhances File Download Helper & Permission Handler (iOS/Android support, onboarding flow, simulator compatibility, permission logic, component app updates).

- **[#199 – Core → Price-Currency-Info-Helper](https://github.com/masterfabric-mobile/osmea/pull/199)**  
  Old `PriceFormatWithCurrencyHelper` deprecated and replaced by `CurrencyHelper` (method signatures, global state, extension usage, migration required).

- **[#198 – Core → Splash View and Storefront Update](https://github.com/masterfabric-mobile/osmea/pull/198)**  
  Adds splash screen feature, improved splash/onboarding/storefront integration, configuration, state management.

- **[#194 – Core → Core-Base-View-Cubit-Export](https://github.com/masterfabric-mobile/osmea/pull/194)**  
  Typedef breaking change: `BuilderCondition` renamed to `BuilderConditionCubit` (refactoring that breaks consumers using the old typedef).

- **[#193 – Core → Core-Base-Cubit-Export](https://github.com/masterfabric-mobile/osmea/pull/193)**  
  Fixes missing export for `BaseViewModelCubit` class in core.dart; makes base class accessible to consumers.

- **[#192 – Core → File Download Helper & Application Share Helper](https://github.com/masterfabric-mobile/osmea/pull/192)**  
  Adds ApplicationShareHelper for unified sharing; upgrades FileDownloadHelper (public storage, file opening/sharing, permission integration, robust error handling).

- **[#191 – Core → Url Launcher Helper](https://github.com/masterfabric-mobile/osmea/pull/191)**  
  Adds UrlLauncherHelper for robust, cross-platform URL launching, validation, social/media/maps integration, error handling.

- **[#188 – Core → Datetime Helper](https://github.com/masterfabric-mobile/osmea/pull/188)**  
  Adds DateTimeHelper with comprehensive date/time utilities, formatting, parsing, duration ops, timezone handling, and validation.

- **[#187 – Core → Permission Handler Helper](https://github.com/masterfabric-mobile/osmea/pull/187)**  
  Adds PermissionHandlerHelper for unified, cross-platform permission management (camera, microphone, location, storage, etc.), intelligent caching, and advanced error handling.

- **[#184 – Core → Double Extension Helper](https://github.com/masterfabric-mobile/osmea/pull/184)**  
  Adds centralized Double Extension Helper for precision, formatting, mathematical operations, and business logic on double values.

- **[#183 – Core → File Download Helper](https://github.com/masterfabric-mobile/osmea/pull/183)**  
  Adds unified FileDownloadHelper for robust, cross-platform file downloads, error handling, progress tracking, and utility functions.

- **[#181 – Core → First Letter Capabilitize Helper](https://github.com/masterfabric-mobile/osmea/pull/181)**  
  Adds `capitalizeFirst()` string extension for first-letter capitalization (core helper utility).

- **[#153 – Projects – Storefront Woo](https://github.com/masterfabric-mobile/osmea/pull/153)**  
  Established the foundation for the Osmea Storefront project. Introduced initial project structure, environment configurations, dependency injection, branding, asset management, multi-flavor support, and licensing. Major architectural addition with project-wide impact.

- **[#135 – OSMEA - Package - API → Network WooCommerce Coupons Batch Update](https://github.com/masterfabric-mobile/osmea/pull/135)**  
  Added batch update functionality and related services for WooCommerce Coupons.

- **[#119 – Admin Dashboard - Basic Configuration and SplashView](https://github.com/masterfabric-mobile/osmea/pull/119)**  
  Created a Flutter-based admin dashboard with modular architecture, localization, routing, dependency injection, environment support, and splash view. Includes core and API packages and asset management.

- **[#111 – WooCommerce Webhooks & System Status API Integration](https://github.com/masterfabric-mobile/osmea/pull/111)**  
  Integrated WooCommerce Webhooks and System Status APIs, added new sidebar navigation categories and icons, introducing significant new features.

- **[#99 – Core Spacer & Grid System](https://github.com/masterfabric-mobile/osmea/pull/99)**  
  Added a centralized layout spacing system and developer grid overlay. Foundational improvement for core UI layout infrastructure.

- **[#11 – Text Standardisation & Typo Fixes](https://github.com/masterfabric-mobile/osmea/pull/11)**  
  Refactored text and comments across handlers, improved error messages, unified terminology, and fixed typos.
