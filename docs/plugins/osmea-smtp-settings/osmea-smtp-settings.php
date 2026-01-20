<?php
/**
 * Plugin Name: OSMEA SMTP Settings
 * Plugin URI: https://github.com/masterfabric-mobile/osmea
 * Description: Configure WordPress SMTP settings (host/port/encryption/auth) and send test emails from the admin panel.
 * Version: 1.0.0
 * Author: MasterFabric Mobile
 * Author URI: https://github.com/masterfabric-mobile
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: osmea-smtp-settings
 * Domain Path: /languages
 */

if (!defined('ABSPATH')) {
    exit;
}

define('OSMEA_SMTP_SETTINGS_VERSION', '1.0.0');
define('OSMEA_SMTP_SETTINGS_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('OSMEA_SMTP_SETTINGS_PLUGIN_URL', plugin_dir_url(__FILE__));
define('OSMEA_SMTP_SETTINGS_OPTION_NAME', 'osmea_smtp_settings');

class OSMEA_SMTP_Settings {
    private static $instance = null;

    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_init', array($this, 'register_settings'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));

        add_action('phpmailer_init', array($this, 'configure_phpmailer'));

        add_action('admin_post_osmea_smtp_send_test', array($this, 'handle_send_test_email'));
        add_filter('plugin_action_links_' . plugin_basename(__FILE__), array($this, 'add_settings_link'));
    }

    public function add_admin_menu() {
        add_options_page(
            __('OSMEA SMTP', 'osmea-smtp-settings'),
            __('OSMEA SMTP', 'osmea-smtp-settings'),
            'manage_options',
            'osmea-smtp-settings',
            array($this, 'render_admin_page')
        );
    }

    public function register_settings() {
        register_setting(
            'osmea_smtp_settings_group',
            OSMEA_SMTP_SETTINGS_OPTION_NAME,
            array(
                'type' => 'array',
                'sanitize_callback' => array($this, 'sanitize_settings'),
                'default' => $this->get_default_settings(),
            )
        );

        add_settings_section(
            'osmea_smtp_main_section',
            __('SMTP Settings', 'osmea-smtp-settings'),
            function() {
                echo '<p class="description">' . esc_html__('These settings are applied to WordPress emails sent via wp_mail().', 'osmea-smtp-settings') . '</p>';
            },
            'osmea-smtp-settings'
        );

        $fields = array(
            'enabled' => __('Enable SMTP', 'osmea-smtp-settings'),
            'host' => __('SMTP Host', 'osmea-smtp-settings'),
            'port' => __('SMTP Port', 'osmea-smtp-settings'),
            'encryption' => __('Encryption', 'osmea-smtp-settings'),
            'auth' => __('Authentication', 'osmea-smtp-settings'),
            'username' => __('Username', 'osmea-smtp-settings'),
            'password' => __('Password', 'osmea-smtp-settings'),
            'auto_tls' => __('Auto TLS', 'osmea-smtp-settings'),
            'disable_ssl_verify' => __('Disable SSL Verification', 'osmea-smtp-settings'),
            'from_email' => __('From Email', 'osmea-smtp-settings'),
            'from_name' => __('From Name', 'osmea-smtp-settings'),
            'force_from' => __('Force From', 'osmea-smtp-settings'),
        );

        foreach ($fields as $key => $label) {
            add_settings_field(
                'osmea_smtp_' . $key,
                $label,
                array($this, 'render_field'),
                'osmea-smtp-settings',
                'osmea_smtp_main_section',
                array('key' => $key)
            );
        }
    }

    private function get_default_settings() {
        return array(
            'enabled' => 0,
            'host' => '',
            'port' => 587,
            'encryption' => 'tls', // none|ssl|tls
            'auth' => 1,
            'username' => '',
            'password' => '',
            'auto_tls' => 1,
            'disable_ssl_verify' => 0,
            'from_email' => '',
            'from_name' => '',
            'force_from' => 0,
        );
    }

    private function sanitize_secret($value) {
        $value = (string) wp_unslash($value);
        $value = trim($value);
        // Remove ASCII control characters; keep everything else intact.
        $value = preg_replace('/[\x00-\x1F\x7F]/u', '', $value);
        return $value;
    }

    public function sanitize_settings($input) {
        $defaults = $this->get_default_settings();
        $existing = get_option(OSMEA_SMTP_SETTINGS_OPTION_NAME, array());
        if (!is_array($existing)) {
            $existing = array();
        }

        $input = is_array($input) ? $input : array();
        $out = array();

        $out['enabled'] = !empty($input['enabled']) ? 1 : 0;
        $out['host'] = isset($input['host']) ? sanitize_text_field($input['host']) : $defaults['host'];
        $out['port'] = isset($input['port']) ? absint($input['port']) : $defaults['port'];
        if (empty($out['port'])) {
            $out['port'] = $defaults['port'];
        }

        $enc = isset($input['encryption']) ? (string) $input['encryption'] : $defaults['encryption'];
        $out['encryption'] = in_array($enc, array('none', 'ssl', 'tls'), true) ? $enc : $defaults['encryption'];

        $out['auth'] = !empty($input['auth']) ? 1 : 0;
        $out['username'] = isset($input['username']) ? sanitize_text_field($input['username']) : $defaults['username'];

        // Password: only update when a non-empty value is submitted.
        if (isset($input['password']) && $input['password'] !== '') {
            $out['password'] = $this->sanitize_secret($input['password']);
        } elseif (isset($existing['password'])) {
            $out['password'] = (string) $existing['password'];
        } else {
            $out['password'] = $defaults['password'];
        }

        $out['auto_tls'] = !empty($input['auto_tls']) ? 1 : 0;
        $out['disable_ssl_verify'] = !empty($input['disable_ssl_verify']) ? 1 : 0;

        $out['from_email'] = isset($input['from_email']) ? sanitize_email($input['from_email']) : $defaults['from_email'];
        $out['from_name'] = isset($input['from_name']) ? sanitize_text_field($input['from_name']) : $defaults['from_name'];
        $out['force_from'] = !empty($input['force_from']) ? 1 : 0;

        return $out;
    }

    private function get_settings() {
        $settings = get_option(OSMEA_SMTP_SETTINGS_OPTION_NAME, $this->get_default_settings());
        if (!is_array($settings)) {
            $settings = array();
        }
        return array_merge($this->get_default_settings(), $settings);
    }

    private function get_setting_with_constant_override($key, $settings) {
        $map = array(
            'enabled' => 'OSMEA_SMTP_ENABLED',
            'host' => 'OSMEA_SMTP_HOST',
            'port' => 'OSMEA_SMTP_PORT',
            'encryption' => 'OSMEA_SMTP_ENCRYPTION',
            'auth' => 'OSMEA_SMTP_AUTH',
            'username' => 'OSMEA_SMTP_USERNAME',
            'password' => 'OSMEA_SMTP_PASSWORD',
            'auto_tls' => 'OSMEA_SMTP_AUTO_TLS',
            'disable_ssl_verify' => 'OSMEA_SMTP_DISABLE_SSL_VERIFY',
            'from_email' => 'OSMEA_SMTP_FROM_EMAIL',
            'from_name' => 'OSMEA_SMTP_FROM_NAME',
            'force_from' => 'OSMEA_SMTP_FORCE_FROM',
        );

        if (isset($map[$key]) && defined($map[$key])) {
            return constant($map[$key]);
        }

        return isset($settings[$key]) ? $settings[$key] : null;
    }

    public function enqueue_admin_assets($hook) {
        if ($hook !== 'settings_page_osmea-smtp-settings') {
            return;
        }

        $css_version = file_exists(OSMEA_SMTP_SETTINGS_PLUGIN_DIR . 'assets/admin.css')
            ? filemtime(OSMEA_SMTP_SETTINGS_PLUGIN_DIR . 'assets/admin.css')
            : OSMEA_SMTP_SETTINGS_VERSION;

        wp_enqueue_style(
            'osmea-smtp-settings-admin',
            OSMEA_SMTP_SETTINGS_PLUGIN_URL . 'assets/admin.css',
            array(),
            $css_version
        );

        wp_enqueue_script(
            'osmea-smtp-settings-admin',
            OSMEA_SMTP_SETTINGS_PLUGIN_URL . 'assets/admin.js',
            array(),
            OSMEA_SMTP_SETTINGS_VERSION,
            true
        );
    }

    public function configure_phpmailer($phpmailer) {
        $settings = $this->get_settings();

        $enabled = (int) $this->get_setting_with_constant_override('enabled', $settings);
        if (!$enabled) {
            return;
        }

        $host = (string) $this->get_setting_with_constant_override('host', $settings);
        if ($host === '') {
            return;
        }

        $phpmailer->isSMTP();
        $phpmailer->Host = $host;
        $phpmailer->Port = (int) $this->get_setting_with_constant_override('port', $settings);

        $enc = (string) $this->get_setting_with_constant_override('encryption', $settings);
        $phpmailer->SMTPSecure = ($enc === 'none') ? '' : $enc;

        $auto_tls = (int) $this->get_setting_with_constant_override('auto_tls', $settings);
        $phpmailer->SMTPAutoTLS = $auto_tls ? true : false;

        $auth = (int) $this->get_setting_with_constant_override('auth', $settings);
        $phpmailer->SMTPAuth = $auth ? true : false;

        if ($phpmailer->SMTPAuth) {
            $phpmailer->Username = (string) $this->get_setting_with_constant_override('username', $settings);
            $phpmailer->Password = (string) $this->get_setting_with_constant_override('password', $settings);
        }

        $disable_ssl_verify = (int) $this->get_setting_with_constant_override('disable_ssl_verify', $settings);
        if ($disable_ssl_verify) {
            $phpmailer->SMTPOptions = array(
                'ssl' => array(
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true,
                ),
            );
        }

        $force_from = (int) $this->get_setting_with_constant_override('force_from', $settings);
        $from_email = (string) $this->get_setting_with_constant_override('from_email', $settings);
        $from_name = (string) $this->get_setting_with_constant_override('from_name', $settings);

        if ($force_from && $from_email !== '') {
            try {
                $phpmailer->setFrom($from_email, $from_name, false);
            } catch (Exception $e) {
                // Ignore invalid From values; wp_mail() will handle defaults.
            }
        }
    }

    public function add_settings_link($links) {
        $url = admin_url('options-general.php?page=osmea-smtp-settings');
        $links[] = '<a href="' . esc_url($url) . '">' . esc_html__('Settings', 'osmea-smtp-settings') . '</a>';
        return $links;
    }

    public function render_admin_page() {
        if (!current_user_can('manage_options')) {
            wp_die(__('You do not have permission to access this page.', 'osmea-smtp-settings'));
        }

        $test_status = isset($_GET['osmea_smtp_test']) ? sanitize_text_field(wp_unslash($_GET['osmea_smtp_test'])) : '';
        $test_error = '';
        if ($test_status === 'error') {
            $test_error = (string) get_transient('osmea_smtp_last_test_error');
            delete_transient('osmea_smtp_last_test_error');
        } elseif ($test_status === 'success') {
            delete_transient('osmea_smtp_last_test_error');
        }
        ?>
        <div class="wrap osmea-smtp-wrap">
            <h1><?php echo esc_html(get_admin_page_title()); ?></h1>

            <?php settings_errors(); ?>

            <?php if ($test_status === 'success') : ?>
                <div class="notice notice-success is-dismissible"><p><?php esc_html_e('Test email sent successfully.', 'osmea-smtp-settings'); ?></p></div>
            <?php elseif ($test_status === 'error') : ?>
                <div class="notice notice-error is-dismissible">
                    <p><?php esc_html_e('Test email failed to send.', 'osmea-smtp-settings'); ?></p>
                    <?php if (!empty($test_error)) : ?>
                        <p><code><?php echo esc_html($test_error); ?></code></p>
                    <?php endif; ?>
                </div>
            <?php elseif ($test_status === 'missing') : ?>
                <div class="notice notice-warning is-dismissible"><p><?php esc_html_e('Please enter a valid test email address.', 'osmea-smtp-settings'); ?></p></div>
            <?php endif; ?>

            <form method="post" action="options.php">
                <?php
                settings_fields('osmea_smtp_settings_group');
                do_settings_sections('osmea-smtp-settings');
                submit_button(__('Save Settings', 'osmea-smtp-settings'));
                ?>
            </form>

            <hr />

            <h2><?php esc_html_e('Send Test Email', 'osmea-smtp-settings'); ?></h2>
            <p class="description"><?php esc_html_e('Send a test email using the current SMTP settings.', 'osmea-smtp-settings'); ?></p>

            <form method="post" action="<?php echo esc_url(admin_url('admin-post.php')); ?>">
                <?php wp_nonce_field('osmea_smtp_send_test'); ?>
                <input type="hidden" name="action" value="osmea_smtp_send_test" />

                <table class="form-table" role="presentation">
                    <tbody>
                        <tr>
                            <th scope="row">
                                <label for="osmea_smtp_test_to"><?php esc_html_e('To', 'osmea-smtp-settings'); ?></label>
                            </th>
                            <td>
                                <input type="email" class="regular-text" id="osmea_smtp_test_to" name="to" value="" placeholder="name@example.com" required />
                                <p class="description"><?php esc_html_e('Recipient address for the test email.', 'osmea-smtp-settings'); ?></p>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <?php submit_button(__('Send Test Email', 'osmea-smtp-settings'), 'secondary'); ?>
            </form>

            <div class="osmea-smtp-hints">
                <h2><?php esc_html_e('Optional: wp-config.php Overrides', 'osmea-smtp-settings'); ?></h2>
                <p class="description">
                    <?php esc_html_e('You can override settings via constants in wp-config.php (useful for production). Example:', 'osmea-smtp-settings'); ?>
                </p>
                <pre><code>define('OSMEA_SMTP_ENABLED', 1);
define('OSMEA_SMTP_HOST', 'smtp.example.com');
define('OSMEA_SMTP_PORT', 587);
define('OSMEA_SMTP_ENCRYPTION', 'tls'); // none|ssl|tls
define('OSMEA_SMTP_AUTH', 1);
define('OSMEA_SMTP_USERNAME', 'user@example.com');
define('OSMEA_SMTP_PASSWORD', 'your-password');</code></pre>
            </div>
        </div>
        <?php
    }

    public function render_field($args) {
        $key = isset($args['key']) ? (string) $args['key'] : '';
        $settings = $this->get_settings();
        $name = OSMEA_SMTP_SETTINGS_OPTION_NAME . '[' . $key . ']';
        $value = isset($settings[$key]) ? $settings[$key] : '';

        switch ($key) {
            case 'enabled':
            case 'auth':
            case 'auto_tls':
            case 'disable_ssl_verify':
            case 'force_from':
                printf(
                    '<label><input type="checkbox" name="%s" value="1" %s /> %s</label>',
                    esc_attr($name),
                    checked(!empty($value), true, false),
                    esc_html__('Yes', 'osmea-smtp-settings')
                );
                if ($key === 'disable_ssl_verify') {
                    echo '<p class="description">' . esc_html__('Not recommended unless you know you need it (self-signed certificates).', 'osmea-smtp-settings') . '</p>';
                }
                if ($key === 'auto_tls') {
                    echo '<p class="description">' . esc_html__('Automatically use TLS when available (recommended).', 'osmea-smtp-settings') . '</p>';
                }
                if ($key === 'force_from') {
                    echo '<p class="description">' . esc_html__('Force the From name/email for all outgoing emails.', 'osmea-smtp-settings') . '</p>';
                }
                break;

            case 'host':
                printf(
                    '<input type="text" class="regular-text" name="%s" value="%s" placeholder="smtp.example.com" />',
                    esc_attr($name),
                    esc_attr((string) $value)
                );
                break;

            case 'port':
                printf(
                    '<input type="number" min="1" max="65535" class="small-text" name="%s" value="%s" />',
                    esc_attr($name),
                    esc_attr((string) $value)
                );
                break;

            case 'encryption':
                $options = array(
                    'none' => __('None', 'osmea-smtp-settings'),
                    'ssl' => __('SSL', 'osmea-smtp-settings'),
                    'tls' => __('TLS', 'osmea-smtp-settings'),
                );
                echo '<select name="' . esc_attr($name) . '">';
                foreach ($options as $opt_value => $label) {
                    echo '<option value="' . esc_attr($opt_value) . '" ' . selected((string) $value, (string) $opt_value, false) . '>' . esc_html($label) . '</option>';
                }
                echo '</select>';
                break;

            case 'username':
                printf(
                    '<input type="text" class="regular-text" name="%s" value="%s" autocomplete="off" />',
                    esc_attr($name),
                    esc_attr((string) $value)
                );
                break;

            case 'password':
                $has_password = !empty($value);
                printf(
                    '<input type="password" class="regular-text osmea-smtp-password" name="%s" value="" autocomplete="new-password" placeholder="%s" />',
                    esc_attr($name),
                    esc_attr($has_password ? __('(saved) Leave blank to keep current password', 'osmea-smtp-settings') : __('Enter password', 'osmea-smtp-settings'))
                );
                echo '<p class="description">' . esc_html__('Password is stored in the database. Leave blank to keep the existing one.', 'osmea-smtp-settings') . '</p>';
                break;

            case 'from_email':
                printf(
                    '<input type="email" class="regular-text" name="%s" value="%s" placeholder="no-reply@example.com" />',
                    esc_attr($name),
                    esc_attr((string) $value)
                );
                break;

            case 'from_name':
                printf(
                    '<input type="text" class="regular-text" name="%s" value="%s" placeholder="%s" />',
                    esc_attr($name),
                    esc_attr((string) $value),
                    esc_attr(get_bloginfo('name'))
                );
                break;

            default:
                // Fallback
                printf(
                    '<input type="text" class="regular-text" name="%s" value="%s" />',
                    esc_attr($name),
                    esc_attr((string) $value)
                );
        }
    }

    public function handle_send_test_email() {
        if (!current_user_can('manage_options')) {
            wp_die(__('You do not have permission to perform this action.', 'osmea-smtp-settings'));
        }

        check_admin_referer('osmea_smtp_send_test');

        $to = isset($_POST['to']) ? sanitize_email(wp_unslash($_POST['to'])) : '';
        if (empty($to) || !is_email($to)) {
            wp_safe_redirect(admin_url('options-general.php?page=osmea-smtp-settings&osmea_smtp_test=missing'));
            exit;
        }

        delete_transient('osmea_smtp_last_test_error');

        $subject = sprintf(
            /* translators: %s: site name */
            __('OSMEA SMTP Test Email from %s', 'osmea-smtp-settings'),
            wp_specialchars_decode(get_bloginfo('name'), ENT_QUOTES)
        );
        $message = __('If you received this email, your SMTP settings are working.', 'osmea-smtp-settings');

        $error_message = '';
        $capture = function($wp_error) use (&$error_message) {
            if (is_wp_error($wp_error)) {
                $error_message = (string) $wp_error->get_error_message();
            }
        };
        add_action('wp_mail_failed', $capture, 999, 1);

        $sent = wp_mail($to, $subject, $message);
        remove_action('wp_mail_failed', $capture, 999);

        if (!$sent && $error_message !== '') {
            set_transient('osmea_smtp_last_test_error', $error_message, 60);
        }

        $status = $sent ? 'success' : 'error';
        wp_safe_redirect(admin_url('options-general.php?page=osmea-smtp-settings&osmea_smtp_test=' . $status));
        exit;
    }
}

function osmea_smtp_settings_init() {
    return OSMEA_SMTP_Settings::get_instance();
}

add_action('plugins_loaded', 'osmea_smtp_settings_init');

register_activation_hook(__FILE__, function() {
    if (get_option(OSMEA_SMTP_SETTINGS_OPTION_NAME, null) === null) {
        $defaults = array(
            'enabled' => 0,
            'host' => '',
            'port' => 587,
            'encryption' => 'tls',
            'auth' => 1,
            'username' => '',
            'password' => '',
            'auto_tls' => 1,
            'disable_ssl_verify' => 0,
            'from_email' => '',
            'from_name' => '',
            'force_from' => 0,
        );
        add_option(OSMEA_SMTP_SETTINGS_OPTION_NAME, $defaults);
    }
});

