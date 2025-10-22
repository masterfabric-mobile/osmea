// Import all component examples
import 'package:flutter/material.dart';

import '../components/align_example.dart';
import '../components/appbar_example.dart';
import '../components/appbar_searchbar_example.dart';
import '../components/avatar_example.dart';
import '../components/badge_example.dart';
import '../components/bottom_sheet_example.dart';
import '../components/button_example.dart';
import '../components/card_example.dart';
import '../components/carousel_example.dart';
import '../components/center_example.dart';
import '../components/checkbox_example.dart';
import '../components/chips_example.dart';
import '../components/clip_r_rect_example.dart';
import '../components/collapse_example.dart';
import '../components/colors_example.dart';
import '../components/column_example.dart';
import '../components/container_example.dart';
import '../components/counter_example.dart';
import '../components/divider_example.dart';
import '../components/dot_indicator_example.dart';
import '../components/dropdown_example.dart';
import '../components/expanded_example.dart';
import '../components/fitted_box_example.dart';
import '../components/flexible_example.dart';
import '../components/footer_example.dart';
import '../components/image_example.dart';
import '../components/list_item_example.dart';
import '../components/loading_example.dart';
import '../components/padding_example.dart';
import '../components/popup_example.dart';
import '../components/positioned_example.dart';
import '../components/progress_example.dart';
import '../components/radio_button_example.dart';
import '../components/rich_text_example.dart';
import '../components/row_example.dart';
import '../components/scaffold_example.dart';
import '../components/searchbar_example.dart';
import '../components/single_child_scroll_view_example.dart';
import '../components/sized_box_example.dart';
import '../components/snackbar_example.dart';
import '../components/spacer_example.dart';
import '../components/stack_example.dart';
import '../components/stepper_example.dart';
import '../components/switch_button_example.dart';
import '../components/tabbar_example.dart';
import '../components/text_example.dart';
import '../components/text_field_example.dart';
import '../components/phone_picker_example.dart';
import '../components/ticket_widget_example.dart';
import '../components/toast_example.dart';
import '../components/url_launcher_example.dart';
import '../components/viewer_helper_example.dart';
import '../components/wrap_example.dart';
import '../components/application_share_helper_example.dart';
import '../components/file_download_helper_example.dart';
import '../components/sound_dialog_example.dart';
import '../components/location_picker_example.dart';

final List<Map<String, dynamic>> components = [
  {
    'title': 'Location Picker',
    'icon': Icons.location_on_outlined,
    'route': () => const LocationPickerExample(),
  },
  {
    'title': 'Align',
    'icon': Icons.align_horizontal_center_outlined,
    'route': () => const AlignExample(),
  },
  {
    'title': 'AppBar',
    'icon': Icons.view_headline_outlined,
    'route': () => const AppbarShowcase(),
  },
  {
    'title': 'AppBar with SearchBar',
    'icon': Icons.search_outlined,
    'route': () => const AppBarSearchBarExample(),
  },
  {
    'title': 'Avatar',
    'icon': Icons.person_outline,
    'route': () => const AvatarExample(),
  },
  {
    'title': 'Badge',
    'icon': Icons.badge_outlined,
    'route': () => const BadgeExample(),
  },
  {
    'title': 'BottomSheet',
    'icon': Icons.call_to_action_outlined,
    'route': () => const BottomSheetExample(),
  },
  {
    'title': 'Button',
    'icon': Icons.smart_button_outlined,
    'route': () => const ButtonExample(),
  },
  {
    'title': 'Card',
    'icon': Icons.credit_card_outlined,
    'route': () => const CardExample(),
  },
  {
    'title': 'Carousel',
    'icon': Icons.view_carousel_outlined,
    'route': () => const CarouselExample(),
  },
  {
    'title': 'Center',
    'icon': Icons.center_focus_strong_outlined,
    'route': () => const CenterExample(),
  },
  {
    'title': 'Checkbox',
    'icon': Icons.check_box_outlined,
    'route': () => const CheckboxExample(),
  },
  {
    'title': 'Chips',
    'icon': Icons.label_outlined,
    'route': () => const ChipsExample(),
  },
  {
    'title': 'ClipRRect',
    'icon': Icons.crop_16_9_outlined,
    'route': () => const ClipRRectExample(),
  },
  {
    'title': 'Collapse',
    'icon': Icons.expand_less_outlined,
    'route': () => const CollapseExample(),
  },
  {
    'title': 'Colors',
    'icon': Icons.palette_outlined,
    'route': () => const ColorsExample(),
  },
  {
    'title': 'Column',
    'icon': Icons.view_column_outlined,
    'route': () => const ColumnExample(),
  },
  {
    'title': 'Container',
    'icon': Icons.crop_square_outlined,
    'route': () => const ContainerExample(),
  },
  {
    'title': 'Counter',
    'icon': Icons.exposure_outlined,
    'route': () => const CounterExample(),
  },
  {
    'title': 'Divider',
    'icon': Icons.remove_outlined,
    'route': () => const DividerExample(),
  },
  {
    'title': 'DotIndicator',
    'icon': Icons.more_horiz_outlined,
    'route': () => const DotIndicatorExample(),
  },
  {
    'title': 'Dropdown',
    'icon': Icons.arrow_drop_down_outlined,
    'route': () => const DropdownExample(),
  },
  {
    'title': 'Expanded',
    'icon': Icons.open_in_full_outlined,
    'route': () => const ExpandedExample(),
  },
  {
    'title': 'FittedBox',
    'icon': Icons.fit_screen_outlined,
    'route': () => const FittedBoxExample(),
  },
  {
    'title': 'Flexible',
    'icon': Icons.fit_screen_outlined,
    'route': () => const FlexibleExample(),
  },
  {
    'title': 'Footer',
    'icon': Icons.vertical_align_bottom_outlined,
    'route': () => const FooterExample(),
  },
  {
    'title': 'Image',
    'icon': Icons.image_outlined,
    'route': () => const ImageExample(),
  },
  {
    'title': 'ListItem',
    'icon': Icons.list_outlined,
    'route': () => const ListItemExample(),
  },
  {
    'title': 'Loading',
    'icon': Icons.hourglass_empty_outlined,
    'route': () => const LoadingExample(),
  },
  {
    'title': 'Padding',
    'icon': Icons.padding_outlined,
    'route': () => const PaddingExample(),
  },
  {
    'title': 'Popup',
    'icon': Icons.open_in_new_outlined,
    'route': () => const PopupExample(),
  },
  {
    'title': 'Positioned',
    'icon': Icons.gps_fixed_outlined,
    'route': () => const PositionedExample(),
  },
  {
    'title': 'Progress',
    'icon': Icons.trending_up_outlined,
    'route': () => const ProgressExample(),
  },
  {
    'title': 'RadioButton',
    'icon': Icons.radio_button_checked_outlined,
    'route': () => const RadioButtonExample(),
  },
  {
    'title': 'RichText',
    'icon': Icons.text_fields_outlined,
    'route': () => const RichTextExample(),
  },
  {
    'title': 'Row',
    'icon': Icons.view_agenda_outlined,
    'route': () => const RowExample(),
  },
  {
    'title': 'Scaffold',
    'icon': Icons.view_agenda_outlined,
    'route': () => const ScaffoldExample(),
  },
  {
    'title': 'Searchbar',
    'icon': Icons.search_outlined,
    'route': () => const SearchbarExample(),
  },
  {
    'title': 'ScrollView',
    'icon': Icons.swipe,
    'route': () => const SingleChildScrollViewExample(),
  },
  {
    'title': 'SizedBox',
    'icon': Icons.crop_square_outlined,
    'route': () => const SizedBoxExample(),
  },
  {
    'title': 'Snackbar',
    'icon': Icons.message_outlined,
    'route': () => const SnackbarExample(),
  },
  {
    'title': 'Sound Dialog',
    'icon': Icons.mic_none_outlined,
    'route': () => const SoundDialogExample(),
  },
  {
    'title': 'Spacer',
    'icon': Icons.space_bar_outlined,
    'route': () => const SpacerExample(),
  },
  {
    'title': 'Stack',
    'icon': Icons.layers_outlined,
    'route': () => const StackExample(),
  },
  {
    'title': 'Stepper',
    'icon': Icons.format_list_numbered_outlined,
    'route': () => const StepperExample(),
  },
  {
    'title': 'Switch',
    'icon': Icons.toggle_on_outlined,
    'route': () => const SwitchButtonExample(),
  },
  {
    'title': 'Tabs',
    'icon': Icons.tab_outlined,
    'route': () => const TabBarExample(),
  },
  {
    'title': 'Text',
    'icon': Icons.text_fields_outlined,
    'route': () => const TextExample(),
  },
  {
    'title': 'TextField',
    'icon': Icons.input_outlined,
    'route': () => const TextFieldExample(),
  },
  {
    'title': 'Phone Picker',
    'icon': Icons.phone_outlined,
    'route': () => const PhonePickerExample(),
  },
  {
    'title': 'Ticket',
    'icon': Icons.confirmation_number_outlined,
    'route': () => const TicketWidgetExample(),
  },
  {
    'title': 'Toast',
    'icon': Icons.notifications_outlined,
    'route': () => const ToastExample(),
  },
  {
    'title': 'URL Launcher',
    'icon': Icons.launch_outlined,
    'route': () => const UrlLauncherExample(),
  },
  // FileDownloader moved to Helpers screen
  {
    'title': 'Wrap',
    'icon': Icons.wrap_text_outlined,
    'route': () => const WrapExample(),
  },
  {
    'title': 'Application Share Helper',
    'icon': Icons.share_outlined,
    'route': () => const ApplicationShareHelperExample(),
  },
  {
    'title': 'File Download Helper',
    'icon': Icons.download_outlined,
    'route': () => const FileDownloadHelperExample(),
  },
  {
    'title': 'Viewer Helper',
    'icon': Icons.web_outlined,
    'route': () => const ViewerHelperExample(),
  },
];
