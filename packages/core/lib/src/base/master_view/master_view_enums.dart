part of master_view; // Indicate that this file is part of the master_view library

// Enum representing different states of the MasterView
enum MasterViewTypes {
  loading, // Represents a loading state
  content, // Represents the content state
  error, // Represents an error state
  empty, // Represents an empty state (no data)
  unauthorized, // Represents an unauthorized access state
  timeout, // Represents a timeout state
  maintenance, // Represents a maintenance state
  webview, // Represents a webview state
}
