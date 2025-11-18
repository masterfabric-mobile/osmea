/// Stub for dart:html on non-web platforms
/// This file provides empty stubs for web-only functionality

// Empty stub for document when not on web
class _DocumentStub {
  String? get cookie => null;
}

// Create a document instance for the stub
final _document = _DocumentStub();

// Make document accessible similar to dart:html
_DocumentStub get document => _document;
