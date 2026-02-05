/**
 * OSMEA App Config Manager – Entry point
 * Calls formInit when DOM ready. osmea-data + osmea-form must be loaded.
 */
(function ($) {
    'use strict';
    if (typeof $ !== 'function' || !$.fn || !$.fn.jquery) return;
    if (typeof window.OSMEA_Config === 'undefined' || typeof window.OSMEA_Config.formInit !== 'function') return;

    $(document).ready(function () {
        var $form = $('#osmea-config-form');
        if (!$form.length) return;

        window.OSMEA_Config.formInit({
            form: $form,
            tabbar: $('#osmea-config-tabbar'),
            sections: $('#osmea-config-ui-sections'),
            status: $('#osmea-json-status'),
            hiddenStore: $('#osmea-config-json-store')
        });
    });
})(jQuery);
