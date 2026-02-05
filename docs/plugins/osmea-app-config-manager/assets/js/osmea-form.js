/**
 * OSMEA App Config Manager – Form layer
 * Config get/set, dirty state, render, buildForm, submit/reset. Uses jQuery + OSMEA_Config.
 */
(function ($, N) {
    'use strict';
    if (typeof $ !== 'function' || !N || !N.getFieldDefinitions) return;

    N.formInit = function (opts) {
        var $form = opts.form;
        var $tabbar = opts.tabbar;
        var $uiSections = opts.sections;
        var $status = opts.status;
        var $hiddenStore = opts.hiddenStore;
        var staticTabs = N.getTabs();
        var staticCategories = N.getCategories();
        var tabLabelById = {};
        if (typeof osmeaConfig !== 'undefined' && osmeaConfig.tabLabels && typeof osmeaConfig.tabLabels === 'object') {
            tabLabelById = osmeaConfig.tabLabels;
        } else {
            staticTabs.forEach(function (t) { tabLabelById[t.id] = t.label; });
        }
        var fieldDefinitions;
        try {
            fieldDefinitions = N.getFieldDefinitions();
        } catch (e) {
            if (typeof console !== 'undefined') console.error('OSMEA getFieldDefinitions:', e);
            fieldDefinitions = [];
        }
        if (!Array.isArray(fieldDefinitions)) fieldDefinitions = [];

        if (!$form.length || !$tabbar.length || !$uiSections.length) {
            if ($status.length) $status.addClass('invalid').text('Config container not found.').show();
            return;
        }

        var initialConfigSnapshot = null;

        function getConfigObj() {
            var raw = '';
            if ($hiddenStore.length && $hiddenStore.val()) raw = $hiddenStore.val();
            else if (typeof osmeaConfig !== 'undefined' && osmeaConfig.currentConfig) raw = osmeaConfig.currentConfig;
            if (typeof raw !== 'string') raw = (raw && typeof raw === 'object') ? JSON.stringify(raw) : '{}';
            if (!raw || !raw.trim()) raw = '{}';
            try { return JSON.parse(raw); } catch (e) { return {}; }
        }

        function getConfigSnapshot() {
            try { return JSON.stringify(getConfigObj()); } catch (e) { return ''; }
        }

        function isDirty() {
            return initialConfigSnapshot !== null && getConfigSnapshot() !== initialConfigSnapshot;
        }

        function markClean() {
            initialConfigSnapshot = getConfigSnapshot();
        }

        function updateDirtyUI() {
            if (!$status.length) return;
            if (isDirty()) {
                $status.removeClass('valid invalid').addClass('unsaved')
                    .text(typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.unsavedChanges ? osmeaConfig.strings.unsavedChanges : 'Unsaved changes.')
                    .show();
            } else {
                $status.removeClass('unsaved');
                if (!$status.hasClass('valid') && !$status.hasClass('invalid')) $status.hide();
            }
        }

        function setConfigObj(obj) {
            $hiddenStore.val(JSON.stringify(obj, null, 2));
            updateDirtyUI();
        }

        function getValueByPath(obj, path) {
            if (!obj || !path) return undefined;
            return path.split('.').reduce(function (acc, key) {
                return (acc && Object.prototype.hasOwnProperty.call(acc, key)) ? acc[key] : undefined;
            }, obj);
        }

        function setValueByPath(obj, path, value) {
            if (!obj || !path) return;
            var keys = path.split('.');
            var current = obj;
            for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
                if (i === keys.length - 1) current[key] = value;
                else {
                    if (!current[key] || typeof current[key] !== 'object') current[key] = {};
                    current = current[key];
                }
            }
        }

        function getFieldId(path) {
            return 'osmea-field-' + path.replace(/\./g, '-').replace(/\[|\]/g, '-');
        }

        function toHex6(val) {
            if (!val || typeof val !== 'string') return '#000000';
            var m = val.match(/^#?([a-fA-F0-9]{6})$/);
            if (m) return '#' + m[1];
            m = val.match(/^#?([a-fA-F0-9]{8})$/);
            if (m) return '#' + m[1].slice(0, 6);
            return val.length >= 6 ? ('#' + String(val).replace(/^#/, '').slice(0, 6)) : '#000000';
        }

        function pathToGroupLabel(path) {
            var parts = path.split('.');
            if (parts.length < 2) return '';
            var last = parts[parts.length - 2];
            return last.replace(/_/g, ' ').replace(/\b\w/g, function (c) { return c.toUpperCase(); });
        }

        function getAccordionGroupKey(field, tabId) {
            var parts = (field.path || '').split('.');
            if (parts[0] !== tabId || parts.length < 2) return tabId;
            return parts[1];
        }

        function accordionGroupLabel(key) {
            return String(key).replace(/_/g, ' ').replace(/\b\w/g, function (c) { return c.toUpperCase(); });
        }

        /** Main tabbar: one tab per category (General, Home, Theme&Account, …, Views). No hardcoded indices. */
        function getMainTabs() {
            var cats = staticCategories;
            if (!cats || !cats.length) return [];
            return cats.map(function (c) {
                return { id: c.id, label: c.label || c.id, tabIds: Array.isArray(c.tabIds) ? c.tabIds : [] };
            });
        }

        function renderOneField(configObj, field, $tbody) {
            var currentValue = getValueByPath(configObj, field.path);
            if (field.path === 'localization_configuration.supported_languages' && Array.isArray(currentValue)) {
                currentValue = (currentValue || []).join(', ');
            }
            var fieldId = getFieldId(field.path);
            var $row = $('<tr class="osmea-field-row"/>');
            var $th = $('<th scope="row"/>').append($('<label/>', { 'for': fieldId, text: field.label }));
            var $td = $('<td/>');
            var $input;
            if (field.type === 'boolean') {
                $input = $('<input type="checkbox" class="osmea-field-boolean"/>').attr('id', fieldId).data('path', field.path);
                $input.prop('checked', Boolean(currentValue));
                $td.append($('<label/>').append($input).append(document.createTextNode(' Yes')));
            } else if (field.type === 'number') {
                $input = $('<input type="number" class="regular-text osmea-field-number"/>').attr('id', fieldId).data('path', field.path);
                $input.val(currentValue === undefined || currentValue === null ? '' : Number(currentValue));
                $td.append($input);
            } else if (field.type === 'select' && Array.isArray(field.options)) {
                $input = $('<select class="osmea-field-select"/>').attr('id', fieldId).data('path', field.path);
                field.options.forEach(function (opt) {
                    $input.append($('<option/>', { value: opt.value, text: opt.label }).prop('selected', currentValue === opt.value));
                });
                $td.append($input);
            } else if (field.type === 'color') {
                var hexVal = (currentValue != null && String(currentValue)) ? toHex6(String(currentValue)) : '#000000';
                var $colorPick = $('<input type="color" class="osmea-field-color-pick"/>').attr('value', hexVal).data('path', field.path);
                var $hexInput = $('<input type="text" class="regular-text osmea-field-color-text"/>').attr('id', fieldId).data('path', field.path).attr('maxlength', 9);
                $hexInput.val(currentValue != null ? String(currentValue) : hexVal);
                $colorPick.on('input change', function () {
                    var h = $(this).val();
                    $hexInput.val(h);
                    var config = getConfigObj();
                    setValueByPath(config, field.path, h);
                    setConfigObj(config);
                });
                $hexInput.on('input change', function () {
                    var h = $(this).val();
                    if (/^#?[a-fA-F0-9]{6}$/.test(h.replace(/^#/, ''))) $colorPick.val('#' + h.replace(/^#/, '').slice(0, 6));
                    var config = getConfigObj();
                    setValueByPath(config, field.path, h || $colorPick.val());
                    setConfigObj(config);
                });
                $td.append($('<div class="osmea-color-row"/>').append($colorPick).append($hexInput));
                $row.append($th).append($td);
                $tbody.append($row);
                return;
            } else if ((field.type === 'text' || field.type === 'image') && N.isImageUrlField(field)) {
                $input = $('<input type="text" class="regular-text osmea-field-text osmea-field-image-url"/>').attr('id', fieldId).data('path', field.path);
                if (field.placeholder) $input.attr('placeholder', field.placeholder);
                $input.val(currentValue === undefined || currentValue === null ? '' : String(currentValue));
                var altText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.imagePreviewAlt) ? osmeaConfig.strings.imagePreviewAlt : 'Preview';
                var $preview = $('<div class="osmea-image-preview-wrap osmea-image-preview-clickable" role="button" tabindex="0" title="View full size"/>').append($('<img class="osmea-image-preview" alt=""/>').attr('alt', altText));
                function updatePreview() {
                    var url = $input.val();
                    var $img = $preview.find('img');
                    if (url && /^https?:\/\//i.test(url)) {
                        $img.attr('src', url).one('error', function () { $img.attr('src', '').addClass('osmea-image-preview-fail'); }).one('load', function () { $img.removeClass('osmea-image-preview-fail'); }).removeClass('osmea-image-preview-fail');
                    } else {
                        $img.attr('src', '').addClass('osmea-image-preview-fail');
                    }
                }
                function openImagePopup(url) {
                    if (!url || !/^https?:\/\//i.test(url)) return;
                    var $lb = $('#osmea-image-lightbox');
                    if (!$lb.length) {
                        $lb = $('<div id="osmea-image-lightbox" class="osmea-image-lightbox" role="dialog" aria-modal="true" aria-label="Image preview"/>')
                            .append($('<div class="osmea-image-lightbox-backdrop"/>'))
                            .append($('<div class="osmea-image-lightbox-content"/>').append($('<img class="osmea-image-lightbox-img" alt=""/>')).append($('<button type="button" class="osmea-image-lightbox-close" aria-label="Close">&times;</button>')));
                        $lb.on('click', '.osmea-image-lightbox-backdrop, .osmea-image-lightbox-close', function () { $lb.removeClass('is-open'); });
                        $lb.find('.osmea-image-lightbox-content').on('click', function (e) { e.stopPropagation(); });
                        $(document.body).append($lb);
                    }
                    $lb.find('.osmea-image-lightbox-img').attr('src', url);
                    $lb.addClass('is-open');
                }
                updatePreview();
                $preview.on('click keydown', function (e) {
                    if (e.type === 'keydown' && e.which !== 13 && e.which !== 32) return;
                    if (e.type === 'click' || e.which === 13 || e.which === 32) {
                        e.preventDefault();
                        var url = $input.val();
                        if (url && /^https?:\/\//i.test(url)) openImagePopup(url);
                    }
                });
                $input.on('change input', function () {
                    var config = getConfigObj();
                    setValueByPath(config, field.path, $(this).val());
                    setConfigObj(config);
                    updatePreview();
                });
                $td.append($('<div class="osmea-image-url-row"/>').append($input).append($preview));
                $row.append($th).append($td);
                $tbody.append($row);
                return;
            } else {
                $input = $('<input type="text" class="regular-text osmea-field-text"/>').attr('id', fieldId).data('path', field.path);
                $input.val(currentValue === undefined || currentValue === null ? '' : String(currentValue));
                $td.append($input);
            }
            $input.on('change input', function () {
                var config = getConfigObj();
                var val;
                if (field.type === 'boolean') val = $(this).is(':checked');
                else if (field.type === 'number') { var v = $(this).val(); val = v === '' ? null : Number(v); }
                else if (field.path === 'localization_configuration.supported_languages') {
                    var s = $(this).val();
                    val = s ? s.split(',').map(function (x) { return x.trim(); }).filter(Boolean) : [];
                } else val = $(this).val();
                setValueByPath(config, field.path, val);
                setConfigObj(config);
            });
            $row.append($th).append($td);
            $tbody.append($row);
        }

        function buildFormFromConfig() {
            var configObj = getConfigObj();
            var mainTabs = getMainTabs();
            $tabbar.empty();
            $uiSections.empty();
            $tabbar.off('click', '.osmea-tab-item');

            function buildAccordionPanel(tabIds) {
                var $wrap = $('<div class="osmea-accordion-wrap"/>');
                var firstOpen = true;
                (tabIds || []).forEach(function (tabId) {
                    var tabFields = fieldDefinitions.filter(function (f) { return f.tab === tabId; });
                    if (tabFields.length === 0) return;
                    var tabLabel = tabLabelById[tabId] || tabId.replace(/_/g, ' ');
                    var $item = $('<div class="osmea-accordion-item"/>').attr('data-tab', tabId);
                    var open = firstOpen;
                    if (firstOpen) firstOpen = false;
                    var $trigger = $('<button type="button" class="osmea-accordion-trigger"/>').attr('aria-expanded', open ? 'true' : 'false').text(tabLabel);
                    var $content = $('<div class="osmea-accordion-content"/>').css('display', open ? 'block' : 'none');
                    var $tbody = $('<tbody/>');
                    tabFields.forEach(function (field) { renderOneField(configObj, field, $tbody); });
                    $content.append($('<table class="form-table" role="presentation"/>').append($tbody));
                    $item.append($trigger).append($content).toggleClass('is-open', open);
                    $wrap.append($item);
                });
                return $wrap;
            }

            function buildOneViewPanel(viewId) {
                var tabFields = fieldDefinitions.filter(function (f) { return f.tab === viewId; });
                if (tabFields.length === 0) return $('<div class="osmea-accordion-wrap"/>');
                var $accWrap = $('<div class="osmea-accordion-wrap"/>');
                var byGroup = {};
                tabFields.forEach(function (f) {
                    var g = getAccordionGroupKey(f, viewId);
                    if (!byGroup[g]) byGroup[g] = [];
                    byGroup[g].push(f);
                });
                Object.keys(byGroup).forEach(function (gk, gi) {
                    var open = gi === 0;
                    var $item = $('<div class="osmea-accordion-item"/>').attr('data-group', gk).toggleClass('is-open', open);
                    var $trigger = $('<button type="button" class="osmea-accordion-trigger"/>').attr('aria-expanded', open ? 'true' : 'false').text(accordionGroupLabel(gk));
                    var $content = $('<div class="osmea-accordion-content"/>').css('display', open ? 'block' : 'none');
                    var $tbody = $('<tbody/>');
                    byGroup[gk].forEach(function (field) { renderOneField(configObj, field, $tbody); });
                    $content.append($('<table class="form-table" role="presentation"/>').append($tbody));
                    $item.append($trigger).append($content);
                    $accWrap.append($item);
                });
                return $accWrap;
            }

            mainTabs.forEach(function (tab, idx) {
                var isFirst = idx === 0;
                $tabbar.append($('<button type="button" class="osmea-tab-item"/>').attr({ 'data-tab': tab.id, 'role': 'tab', 'aria-selected': isFirst ? 'true' : 'false' }).text(tab.label));
                var $panel = $('<div class="osmea-tab-panel"/>').attr({ 'data-tab': tab.id, 'role': 'tabpanel', 'aria-hidden': isFirst ? 'false' : 'true' }).css('display', isFirst ? 'block' : 'none');

                $panel.append($('<div class="osmea-panel-title-row"/>').append($('<h3 class="osmea-panel-title"/>').text(tab.label)));
                if (tab.tabIds && tab.tabIds.length === 1 && tab.id !== 'general') {
                    $panel.append(buildOneViewPanel(tab.tabIds[0]));
                } else {
                    $panel.append(buildAccordionPanel(tab.tabIds || []));
                }
                $uiSections.append($panel);
            });

            $tabbar.on('click', '.osmea-tab-item', function () {
                var id = $(this).data('tab');
                $tabbar.find('.osmea-tab-item').removeClass('active').attr('aria-selected', 'false');
                $(this).addClass('active').attr('aria-selected', 'true');
                $uiSections.find('.osmea-tab-panel').each(function () {
                    var $p = $(this);
                    var on = $p.data('tab') === id;
                    $p.attr('aria-hidden', on ? 'false' : 'true').css('display', on ? 'block' : 'none');
                });
            });
            $tabbar.find('.osmea-tab-item').first().addClass('active');

            $uiSections.on('click', '.osmea-accordion-trigger', function () {
                var $btn = $(this);
                var $item = $btn.closest('.osmea-accordion-item');
                var expanded = $btn.attr('aria-expanded') !== 'true';
                $btn.attr('aria-expanded', expanded ? 'true' : 'false');
                $item.find('.osmea-accordion-content').css('display', expanded ? 'block' : 'none');
                $item.toggleClass('is-open', expanded);
            });

            markClean();
            updateDirtyUI();
        }

        function collectFormIntoConfig() {
            var config = getConfigObj();
            fieldDefinitions.forEach(function (field) {
                var $el = $('#' + getFieldId(field.path));
                if (!$el.length) return;
                var val;
                if (field.type === 'boolean') val = $el.is(':checked');
                else if (field.type === 'number') { var v = $el.val(); val = v === '' ? null : Number(v); }
                else if (field.path === 'localization_configuration.supported_languages') {
                    var s = $el.val();
                    val = s ? s.split(',').map(function (x) { return x.trim(); }).filter(Boolean) : [];
                } else val = $el.val();
                setValueByPath(config, field.path, val);
            });
            return config;
        }

        function applyConfigMetaBeforeSave(config) {
            // Only set client-side "last_updated" hint for smoother UI;
            // authoritative versioning (configVersion, plugin_version, config_revision)
            // is always calculated on the server (PHP) in sanitize_json().
            config.config_meta = config.config_meta || {};
            var now = new Date().toISOString().slice(0, 19).replace('T', ' ');
            config.config_meta.last_updated = now;
            return config;
        }

        function updateMetaLine(meta) {
            var $metaEl = $('#osmea-config-meta');
            if (!$metaEl.length || !(meta.last_updated || meta.plugin_version || meta.configVersion)) return;
            var lastLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.lastUpdated) ? osmeaConfig.strings.lastUpdated : 'Last updated:';
            var verLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.pluginVersion) ? osmeaConfig.strings.pluginVersion : 'Plugin version:';
            var cfgVerLbl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.configVersion) ? osmeaConfig.strings.configVersion : 'Config version:';
            $metaEl.html('<span class="osmea-meta-item">' + lastLbl + ' <strong>' + (meta.last_updated || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + verLbl + ' <strong>' + (meta.plugin_version || '—') + '</strong></span><span class="osmea-meta-sep">|</span><span class="osmea-meta-item">' + cfgVerLbl + ' <strong>' + (meta.configVersion || '—') + '</strong></span>').show();
        }

        $form.on('submit', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var baseUrl = (typeof osmeaConfig !== 'undefined' && osmeaConfig.ajaxUrl) ? osmeaConfig.ajaxUrl : '';
            var saveNonce = (typeof osmeaConfig !== 'undefined' && osmeaConfig.saveNonce) ? osmeaConfig.saveNonce : '';
            var url = baseUrl ? (baseUrl.replace(/\?.*$/, '') + '?action=osmea_save_config') : '';
            if (!url) {
                $status.removeClass('valid').addClass('invalid').text('Save URL not configured.').show();
                return false;
            }
            var config = collectFormIntoConfig();
            if (!config || typeof config !== 'object') {
                $status.removeClass('valid').addClass('invalid').text(typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.invalidJson ? osmeaConfig.strings.invalidJson : 'Invalid config.').show();
                return false;
            }
            config = applyConfigMetaBeforeSave(config);
            var $submitBtn = $form.find('[type="submit"]').first();
            var btnOriginalText = ($submitBtn.val && $submitBtn.val()) ? $submitBtn.val() : ($submitBtn.text && $submitBtn.text());
            var savingText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.saving) ? osmeaConfig.strings.saving : 'Saving...';
            var savedText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.saved) ? osmeaConfig.strings.saved : 'Settings saved.';
            var errorText = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.error) ? osmeaConfig.strings.error : 'Error while saving.';

            $status.removeClass('valid invalid unsaved').hide();
            $submitBtn.prop('disabled', true);
            if ($submitBtn.is('input')) $submitBtn.val(savingText); else $submitBtn.text(savingText);

            $.ajax({
                url: url,
                method: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ nonce: saveNonce, config: config }),
                dataType: 'json',
                success: function (res) {
                    if (res && res.success && res.config) {
                        setConfigObj(res.config);
                        markClean();
                        updateDirtyUI();
                        $status.removeClass('invalid unsaved').addClass('valid').text(res.message || savedText).show();
                        updateMetaLine(res.config.config_meta || {});
                    } else {
                        $status.removeClass('valid').addClass('invalid').text(res && res.message ? res.message : errorText).show();
                    }
                    $submitBtn.prop('disabled', false);
                    if ($submitBtn.is('input')) $submitBtn.val(btnOriginalText); else $submitBtn.text(btnOriginalText);
                },
                error: function (xhr) {
                    var msg = errorText;
                    if (xhr && xhr.responseJSON && xhr.responseJSON.message) msg = xhr.responseJSON.message;
                    else if (xhr && xhr.responseJSON && xhr.responseJSON.code) msg = (xhr.responseJSON.message || xhr.responseJSON.code) || errorText;
                    else if (xhr && xhr.responseText && xhr.status === 403) msg = 'Permission or nonce invalid.';
                    else if (xhr && xhr.status) msg = 'Request failed (' + xhr.status + ').';
                    $status.removeClass('valid unsaved').addClass('invalid').text(msg).show();
                    $submitBtn.prop('disabled', false);
                    if ($submitBtn.is('input')) $submitBtn.val(btnOriginalText); else $submitBtn.text(btnOriginalText);
                }
            });
        });

        window.addEventListener('beforeunload', function (e) {
            if (isDirty()) {
                e.preventDefault();
                e.returnValue = (typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.unsavedChanges) ? osmeaConfig.strings.unsavedChanges : '';
            }
        });

        $('#osmea-reset-config').on('click', function () {
            if (!confirm(typeof osmeaConfig !== 'undefined' ? osmeaConfig.strings.confirmReset : 'Reset to default?')) return;
            var $btn = $(this);
            $btn.prop('disabled', true).text((typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.resetting) ? osmeaConfig.strings.resetting : 'Resetting...');
            var resetBase = (typeof osmeaConfig !== 'undefined' && osmeaConfig.ajaxUrl) ? osmeaConfig.ajaxUrl : '';
            var resetNonce = (typeof osmeaConfig !== 'undefined' && osmeaConfig.resetNonce) ? osmeaConfig.resetNonce : '';
            var resetUrl = resetBase ? (resetBase.replace(/\?.*$/, '') + '?action=osmea_reset_config') : '';
            $.ajax({
                url: resetUrl,
                method: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ nonce: resetNonce }),
                dataType: 'json',
                success: function (res) {
                    if (res.success && res.config) {
                        setConfigObj(res.config);
                        buildFormFromConfig();
                        markClean();
                        updateDirtyUI();
                        $status.removeClass('invalid unsaved').addClass('valid').text((typeof osmeaConfig !== 'undefined' && osmeaConfig.strings && osmeaConfig.strings.resetSuccess) ? osmeaConfig.strings.resetSuccess : 'Reset to default.').show();
                        var cfg = typeof res.config === 'string' ? (function () { try { return JSON.parse(res.config); } catch (e) { return {}; } })() : (res.config || {});
                        updateMetaLine(cfg.config_meta || {});
                    }
                    $btn.prop('disabled', false).text('Reset to Default');
                },
                error: function () {
                    $btn.prop('disabled', false).text('Reset to Default');
                }
            });
        });

        if ($hiddenStore.length && !$hiddenStore.val().trim() && typeof osmeaConfig !== 'undefined' && osmeaConfig.currentConfig) {
            var cfg = osmeaConfig.currentConfig;
            $hiddenStore.val(typeof cfg === 'string' ? cfg : JSON.stringify(cfg || {}));
        }

        try {
            buildFormFromConfig();
            if (typeof osmeaConfig !== 'undefined' && osmeaConfig.configMeta) {
                updateMetaLine(osmeaConfig.configMeta);
            }
        } catch (err) {
            if (typeof console !== 'undefined') console.error('OSMEA buildFormFromConfig:', err);
            if ($status.length) $status.addClass('invalid').text('Could not load form. Check console.').show();
            var tabs = [];
            try { tabs = getMainTabs(); } catch (_) { tabs = [{ id: 'general', label: 'General', tabIds: [] }]; }
            tabs.forEach(function (tab, idx) {
                $tabbar.append($('<button type="button" class="osmea-tab-item"/>').attr('data-tab', tab.id).text(tab.label));
                var $p = $('<div class="osmea-tab-panel"/>').attr('data-tab', tab.id).css('display', idx === 0 ? 'block' : 'none');
                $p.append($('<p/>').text('Error loading this section.'));
                $uiSections.append($p);
            });
        }
    };
})(jQuery, window.OSMEA_Config);
