import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';

class ListItemExample extends StatefulWidget {
  const ListItemExample({super.key});

  @override
  State<ListItemExample> createState() => _ListItemExampleState();
}

class _ListItemExampleState extends State<ListItemExample> {
  String locale = 'en';
  bool checkboxValue = false;
  bool switchValue = true;
  bool radioValue = false;
  bool selectableValue = false;

  String t(String en, String de) => locale == 'en' ? en : de;

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: const OsmeaComponentsAppBar(
        screenKey: 'list_item_example',
      ),
      body: OsmeaComponents.padding(
        padding: const EdgeInsets.all(16),
        child: OsmeaComponents.singleChildScrollView(
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                  t('Standard List Item', 'Standard-Listenelement')),
              OsmeaComponents.listItem(
                leading: const CircleAvatar(
                    child: Icon(Icons.person, color: OsmeaColors.white)),
                title: OsmeaComponents.text(t('Title', 'Titel')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Dense List Item', 'Kompaktes Listenelement')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Dense Item', 'Kompaktes Element')),
                variant: ListItemVariant.dense,
                leading: const Icon(Icons.star),
                trailing: Switch(
                  value: switchValue,
                  onChanged: (v) => setState(() => switchValue = v),
                ),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Outlined List Item', 'Umrandetes Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Outlined Item', 'Umrandetes Element')),
                variant: ListItemVariant.outlined,
                leading: const Icon(Icons.info),
                trailing: const Icon(Icons.arrow_forward),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Filled List Item', 'Gefülltes Listenelement')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Filled Item', 'Gefülltes Element')),
                variant: ListItemVariant.filled,
                leading: const Icon(Icons.inbox),
                trailing: const Icon(Icons.done),
                backgroundColor: OsmeaColors.silver.withValues(alpha: 0.2),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Tonal List Item', 'Tonales Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Tonal Item', 'Tonales Element')),
                variant: ListItemVariant.tonal,
                leading: const Icon(Icons.palette),
                trailing: const Icon(Icons.color_lens),
                backgroundColor: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Ghost List Item', 'Geister-Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Ghost Item', 'Geister-Element')),
                variant: ListItemVariant.switchTile,
                trailing: const Icon(Icons.remove_red_eye_outlined),
                backgroundColor: OsmeaColors.transparent,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Selectable (Checkbox) List Item (Manual)',
                  'Auswählbares (Checkbox) Listenelement (Manuell)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Selectable Item', 'Auswählbares Element')),
                selectable: true,
                selectedType: ListItemSelectedType.checkbox,
                value: checkboxValue,
                onChanged: (v) => setState(() => checkboxValue = v ?? false),
                trailing: const Icon(Icons.check),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Selectable (Radio) List Item (Manual)',
                  'Auswählbares (Radio) Listenelement (Manuell)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Radio Item', 'Radio-Element')),
                selectable: true,
                selectedType: ListItemSelectedType.radio,
                value: radioValue,
                onChanged: (v) => setState(() => radioValue = v ?? false),
                trailing: const Icon(Icons.radio_button_checked),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Switch List Item (Manual)',
                  'Schalter-Listenelement (Manuell)')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Switch Item', 'Schalter-Element')),
                leading: const Icon(Icons.toggle_on),
                trailing: Switch(
                  value: switchValue,
                  onChanged: (v) => setState(() => switchValue = v),
                ),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Button List Item', 'Button-Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Button Item', 'Button-Element')),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: OsmeaComponents.text(t('Action', 'Aktion')),
                ),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Badge List Item', 'Abzeichen-Listenelement')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Badge Item', 'Abzeichen-Element')),
                trailing: Chip(label: OsmeaComponents.text(t('NEW', 'NEU'))),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Avatar List Item', 'Avatar-Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Avatar Item', 'Avatar-Element')),
                leading: const CircleAvatar(child: Icon(Icons.person)),
                trailing: const Icon(Icons.chevron_right),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Dismissible List Item', 'Wischbares Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Swipe to Dismiss', 'Zum Entfernen wischen')),
                onDismissed: (direction) {},
                leading: const Icon(Icons.delete),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Error List Item', 'Fehler-Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Error Item', 'Fehler-Element')),
                leading: Icon(Icons.error, color: OsmeaColors.sunsetGlow),
                error: true,
                trailing: Icon(Icons.warning, color: OsmeaColors.sunsetGlow),
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Disabled List Item', 'Deaktiviertes Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Disabled Item', 'Deaktiviertes Element')),
                leading: const Icon(Icons.block),
                trailing: const Icon(Icons.lock),
                disabled: true,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Multi-line List Item', 'Mehrzeiliges Listenelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Multi-line Item', 'Mehrzeiliges Element')),
                subtitle: OsmeaComponents.text(t(
                    'This is a longer subtitle that wraps onto multiple lines.',
                    'Dies ist ein längerer Untertitel, der in mehrere Zeilen umbricht.')),
                leading: const Icon(Icons.notes),
                maxLines: 3,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Custom Child List Item',
                  'Benutzerdefiniertes Listenelement')),
              OsmeaComponents.listItem(
                padding: const EdgeInsets.all(12),
                backgroundColor: OsmeaColors.springLeaf.withValues(alpha: 0.15),
                child: OsmeaComponents.row(
                  children: [
                    const Icon(Icons.label),
                    OsmeaComponents.sizedBox(width: 8),
                    OsmeaComponents.expanded(
                        child: OsmeaComponents.text(t('Fully customizable row',
                            'Vollständig anpassbare Zeile'))),
                    ElevatedButton(
                        onPressed: () {},
                        child: OsmeaComponents.text(t('Action', 'Aktion'))),
                  ],
                ),
              ),
              // --- List Item Size Examples ---
              OsmeaComponents.text(t('List Item Sizes', 'Listenelement-Größen'),
                  variant: OsmeaTextVariant.titleMedium),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.extraSmall,
                title: OsmeaComponents.text(t('Extra Small', 'Extra Klein')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 12, child: Icon(Icons.person, size: 14)),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.small,
                title: OsmeaComponents.text(t('Small', 'Klein')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 14, child: Icon(Icons.person, size: 16)),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.medium,
                title: OsmeaComponents.text(t('Medium', 'Mittel')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 16, child: Icon(Icons.person, size: 18)),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.large,
                title: OsmeaComponents.text(t('Large', 'Groß')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 20, child: Icon(Icons.person, size: 22)),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.extraLarge,
                title: OsmeaComponents.text(t('Extra Large', 'Extra Groß')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 24, child: Icon(Icons.person, size: 26)),
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                size: ListItemSize.dense,
                title: OsmeaComponents.text(t('Dense', 'Kompakt')),
                subtitle: OsmeaComponents.text(t('Subtitle', 'Untertitel')),
                leading: const CircleAvatar(
                    radius: 12, child: Icon(Icons.person, size: 14)),
              ),
              OsmeaComponents.sizedBox(height: 16),
              // --- List Item Border Variant Examples ---
              OsmeaComponents.text(
                  t('List Item Borders', 'Listenelement-Ränder'),
                  variant: OsmeaTextVariant.titleMedium),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('No Border', 'Kein Rand')),
                leading: const Icon(Icons.border_clear),
                borderVariant: ListItemBorderVariant.none,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('All Sides', 'Alle Seiten')),
                leading: const Icon(Icons.border_all),
                borderVariant: ListItemBorderVariant.all,
                borderColor: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Top Border', 'Oberer Rand')),
                leading: const Icon(Icons.border_top),
                borderVariant: ListItemBorderVariant.top,
                borderColor: OsmeaColors.meadow,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Bottom Border', 'Unterer Rand')),
                leading: const Icon(Icons.border_bottom),
                borderVariant: ListItemBorderVariant.bottom,
                borderColor: OsmeaColors.red,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Left Border', 'Linker Rand')),
                leading: const Icon(Icons.border_left),
                borderVariant: ListItemBorderVariant.left,
                borderColor: OsmeaColors.sunsetGlow,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Right Border', 'Rechter Rand')),
                leading: const Icon(Icons.border_right),
                borderVariant: ListItemBorderVariant.right,
                borderColor: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Custom Border', 'Benutzerdefinierter Rand')),
                leading: const Icon(Icons.border_style),
                borderVariant: ListItemBorderVariant.custom,
                customBorder: Border(
                  top: BorderSide(color: OsmeaColors.nordicBlue, width: 2),
                  bottom: BorderSide(color: OsmeaColors.sunsetGlow, width: 2),
                ),
              ),
              OsmeaComponents.sizedBox(height: 16),
              // --- Multi-side Border Examples ---
              OsmeaComponents.text(
                  t('Multi-side Borders', 'Mehrseitige Ränder'),
                  variant: OsmeaTextVariant.titleMedium),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Top & Bottom', 'Oben & Unten')),
                leading: const Icon(Icons.border_horizontal),
                borderSides: const {
                  ListItemBorderSide.top,
                  ListItemBorderSide.bottom
                },
                borderColor: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Left & Right', 'Links & Rechts')),
                leading: const Icon(Icons.border_vertical),
                borderSides: const {
                  ListItemBorderSide.left,
                  ListItemBorderSide.right
                },
                borderColor: OsmeaColors.sunsetGlow,
              ),
              OsmeaComponents.sizedBox(height: 8),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('All Sides (multi)', 'Alle Seiten (multi)')),
                //width: 150,
                leading: const Icon(Icons.crop_square),
                borderSides: const {
                  ListItemBorderSide.top,
                  ListItemBorderSide.bottom,
                  ListItemBorderSide.left,
                  ListItemBorderSide.right
                },
                borderColor: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Checkbox List Item (Auto Structure)',
                  'Checkbox-Listenelement (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Checkbox Item', 'Checkbox-Element')),
                variant: ListItemVariant.checkbox,
                value: checkboxValue,
                onChanged: (v) => setState(() => checkboxValue = v ?? false),
                // No need to manually add checkbox - it's automatic!
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Radio List Item (Auto Structure)',
                  'Radio-Listenelement (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Radio Item', 'Radio-Element')),
                variant: ListItemVariant.radio,
                value: radioValue,
                onChanged: (v) => setState(() => radioValue = v ?? false),
                // No need to manually add radio - it's automatic!
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Switch List Item (Auto Structure)',
                  'Schalter-Listenelement (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Switch Item', 'Schalter-Element')),
                variant: ListItemVariant.switchTile,
                value: switchValue,
                onChanged: (v) => setState(() => switchValue = v ?? false),
                // No need to manually add switch - it's automatic!
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Checkbox Left (Auto Structure)',
                  'Checkbox Links (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Checkbox Left', 'Checkbox Links')),
                variant: ListItemVariant.checkboxLeft,
                value: checkboxValue,
                onChanged: (v) => setState(() => checkboxValue = v ?? false),
                // Checkbox automatically appears on the left
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Checkbox Right (Auto Structure)',
                  'Checkbox Rechts (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Checkbox Right', 'Checkbox Rechts')),
                variant: ListItemVariant.checkboxRight,
                value: checkboxValue,
                onChanged: (v) => setState(() => checkboxValue = v ?? false),
                // Checkbox automatically appears on the right
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Switch Left (Auto Structure)',
                  'Schalter Links (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Switch Left', 'Schalter Links')),
                variant: ListItemVariant.switchLeft,
                value: switchValue,
                onChanged: (v) => setState(() => switchValue = v ?? false),
                // Switch automatically appears on the left
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Switch Right (Auto Structure)',
                  'Schalter Rechts (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title:
                    OsmeaComponents.text(t('Switch Right', 'Schalter Rechts')),
                variant: ListItemVariant.switchRight,
                value: switchValue,
                onChanged: (v) => setState(() => switchValue = v ?? false),
                // Switch automatically appears on the right
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Radio Left (Auto Structure)',
                  'Radio Links (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Radio Left', 'Radio Links')),
                variant: ListItemVariant.radioLeft,
                value: radioValue,
                onChanged: (v) => setState(() => radioValue = v ?? false),
                // Radio automatically appears on the left
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Radio Right (Auto Structure)',
                  'Radio Rechts (Auto-Struktur)')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Radio Right', 'Radio Rechts')),
                variant: ListItemVariant.radioRight,
                value: radioValue,
                onChanged: (v) => setState(() => radioValue = v ?? false),
                // Radio automatically appears on the right
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                  t('Expandable Menu Item', 'Erweiterbares Menüelement')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(t('Settings', 'Einstellungen')),
                subtitle: OsmeaComponents.text(
                    t('Tap to expand', 'Tippen zum Erweitern')),
                leading: const Icon(Icons.settings),
                variant: ListItemVariant.expandable,
                initiallyExpanded: false,
                onExpansionChanged: (expanded) {},
                children: [
                  // Sub-menu items
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(
                        t('Account Settings', 'Kontoeinstellungen')),
                    leading: const Icon(Icons.person),
                    onTap: () {},
                  ),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(t('Privacy', 'Datenschutz')),
                    leading: const Icon(Icons.security),
                    onTap: () {},
                  ),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(
                        t('Notifications', 'Benachrichtigungen')),
                    leading: const Icon(Icons.notifications),
                    trailing: Switch(
                      value: switchValue,
                      onChanged: (v) => setState(() => switchValue = v),
                    ),
                  ),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(t('Theme', 'Design')),
                    leading: const Icon(Icons.palette),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(t('Expandable with Custom Icons',
                  'Erweiterbar mit benutzerdefinierten Symbolen')),
              OsmeaComponents.listItem(
                title: OsmeaComponents.text(
                    t('Advanced Options', 'Erweiterte Optionen')),
                leading: const Icon(Icons.tune),
                variant: ListItemVariant.expandable,
                initiallyExpanded: true,
                expandIcon: const Icon(Icons.keyboard_arrow_down),
                collapseIcon: const Icon(Icons.keyboard_arrow_up),
                children: [
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(t('Option 1', 'Option 1')),
                    variant: ListItemVariant.checkbox,
                    value: checkboxValue,
                    onChanged: (v) =>
                        setState(() => checkboxValue = v ?? false),
                  ),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(t('Option 2', 'Option 2')),
                    variant: ListItemVariant.switchTile,
                    value: switchValue,
                    onChanged: (v) => setState(() => switchValue = v ?? false),
                  ),
                  OsmeaComponents.listItem(
                    title: OsmeaComponents.text(t('Option 3', 'Option 3')),
                    variant: ListItemVariant.radio,
                    value: radioValue,
                    onChanged: (v) => setState(() => radioValue = v ?? false),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
