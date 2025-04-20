import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResponsePanel extends StatelessWidget {
  final Map<String, dynamic>? responseData;
  final bool loading;

  const ResponsePanel({
    super.key,
    required this.responseData,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Expanded(
            child: responseData != null
                ? _buildJsonResponse(context)
                : _buildPlaceholder(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Response',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        if (responseData != null)
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: const JsonEncoder.withIndent('  ').convert(responseData),
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Response copied to clipboard'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.copy),
            tooltip: 'Copy to clipboard',
          ),
      ],
    );
  }

  Widget _buildJsonResponse(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark slate for better contrast
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          const JsonEncoder.withIndent('  ').convert(responseData),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            loading ? Icons.hourglass_empty : Icons.code,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            loading ? 'Processing request...' : 'No response data yet',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
