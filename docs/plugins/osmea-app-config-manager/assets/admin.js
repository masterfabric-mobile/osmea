/**
 * OSMEA App Config Manager - Admin JavaScript
 */

(function($) {
    'use strict';

    $(document).ready(function() {
        const $editor = $('.osmea-json-editor');
        const $status = $('#osmea-json-status');
        const $form = $('#osmea-config-form');
        
        // JSON validation on input
        $editor.on('input', function() {
            validateJSON();
        });
        
        // Format JSON button
        $('#osmea-format-json').on('click', function() {
            formatJSON();
        });
        
        // Reset to default button
        $('#osmea-reset-config').on('click', function() {
            if (confirm(osmeaConfig.strings.confirmReset)) {
                resetToDefault();
            }
        });
        
        // Export config button
        $('#osmea-export-config').on('click', function() {
            exportConfig();
        });
        
        // Import config button
        $('#osmea-import-config').on('click', function() {
            $('#osmea-import-file').click();
        });
        
        // Handle file import
        $('#osmea-import-file').on('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                importConfig(file);
            }
        });
        
        // Form submission
        $form.on('submit', function(e) {
            if (!validateJSON()) {
                e.preventDefault();
                return false;
            }
            
            // Show saving state
            $editor.addClass('saving');
            const $submitBtn = $form.find('input[type="submit"]');
            const originalText = $submitBtn.val();
            $submitBtn.val(osmeaConfig.strings.saving).prop('disabled', true);
            
            // Re-enable after a short delay (form will submit normally)
            setTimeout(function() {
                $editor.removeClass('saving');
                $submitBtn.val(originalText).prop('disabled', false);
            }, 1000);
        });
        
        /**
         * Validate JSON
         */
        function validateJSON() {
            const jsonText = $editor.val();
            
            if (!jsonText.trim()) {
                showStatus('invalid', osmeaConfig.strings.invalidJson);
                return false;
            }
            
            try {
                JSON.parse(jsonText);
                showStatus('valid', '✓ Valid JSON format');
                return true;
            } catch (e) {
                showStatus('invalid', osmeaConfig.strings.invalidJson + ': ' + e.message);
                return false;
            }
        }
        
        /**
         * Show status message
         */
        function showStatus(type, message) {
            $status
                .removeClass('valid invalid')
                .addClass(type)
                .text(message);
        }
        
        /**
         * Format JSON
         */
        function formatJSON() {
            const jsonText = $editor.val();
            
            if (!jsonText.trim()) {
                alert(osmeaConfig.strings.invalidJson);
                return;
            }
            
            try {
                const parsed = JSON.parse(jsonText);
                const formatted = JSON.stringify(parsed, null, 2);
                $editor.val(formatted);
                validateJSON();
            } catch (e) {
                alert(osmeaConfig.strings.invalidJson + ': ' + e.message);
            }
        }
        
        /**
         * Reset to default config
         */
        function resetToDefault() {
            $.ajax({
                url: osmeaConfig.restUrl,
                method: 'GET',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('X-WP-Nonce', osmeaConfig.nonce);
                },
                success: function(response) {
                    // This would need to fetch default from somewhere
                    // For now, we'll just clear and let user know
                    if (confirm('Reload the page to load default configuration. Continue?')) {
                        location.reload();
                    }
                },
                error: function() {
                    alert(osmeaConfig.strings.error);
                }
            });
        }
        
        /**
         * Export config as JSON file
         */
        function exportConfig() {
            const jsonText = $editor.val();
            
            if (!jsonText.trim()) {
                alert('No data to export.');
                return;
            }
            
            try {
                // Validate JSON
                JSON.parse(jsonText);
                
                // Create download
                const blob = new Blob([jsonText], { type: 'application/json' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'app_config_' + new Date().toISOString().split('T')[0] + '.json';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            } catch (e) {
                alert(osmeaConfig.strings.invalidJson + ': ' + e.message);
            }
        }
        
        /**
         * Import config from file
         */
        function importConfig(file) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                const content = e.target.result;
                
                try {
                    // Validate JSON
                    const parsed = JSON.parse(content);
                    const formatted = JSON.stringify(parsed, null, 2);
                    $editor.val(formatted);
                    validateJSON();
                    
                    // Show success message
                    showStatus('valid', '✓ Configuration imported successfully');
                } catch (e) {
                    alert(osmeaConfig.strings.invalidJson + ': ' + e.message);
                }
            };
            
            reader.onerror = function() {
                alert('File could not be read.');
            };
            
            reader.readAsText(file);
        }
        
        // Initial validation
        validateJSON();
    });
    
})(jQuery);

