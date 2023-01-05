
using Gtk;

namespace Forgetpass {
	public class MainWindow : Adw.ApplicationWindow {
        private PasswordEntry generated_pass;
        private Adw.PasswordEntryRow entry_key;
        private Adw.EntryRow entry_site;
        private Adw.ToastOverlay overlay;
        private Adw.Toast name_toast;
        private Adw.Toast keyword_toast;

		public MainWindow (Adw.Application app) {
			Object (application: app, title: "Forgetpass", default_height: 250, default_width: 300);
		}

		construct {
            entry_site = new Adw.EntryRow();
            entry_site.set_title(_("Site"));
            entry_site.set_tooltip_text(_("Use only the domain name without prefixes, such as http or www, and endings, such as .com, etc."));

            entry_key = new Adw.PasswordEntryRow();
            entry_key.set_title(_("Keyword"));
            entry_key.set_tooltip_text(_("Be sure to remember the keyword! If you forget it, you won't be able to recover your password!"));

            var list = new ListBox();
             list.add_css_class("boxed-list");
             list.append(entry_site);
             list.append(entry_key);

            var generate_button = new Button.with_label(_("GENERATE"));
            generate_button.add_css_class("suggested-action");
            generated_pass = new PasswordEntry() {
                hexpand = true,
                show_peek_icon = true,
                editable = false
            };     
            var copy_button = new Button();
            copy_button.set_icon_name("edit-copy-symbolic");

            generate_button.clicked.connect(on_generate);
            copy_button.clicked.connect(on_copy);

            var hbox_pass = new Box (Orientation.HORIZONTAL, 5);
            hbox_pass.append (generated_pass);
            hbox_pass.append (copy_button);

            var box = new Box (Orientation.VERTICAL, 10);
            box.vexpand = true;
            box.append(list);
            box.append(generate_button);
            box.append(hbox_pass);

            var clamp = new Adw.Clamp ();
            clamp.valign = Gtk.Align.CENTER;
            clamp.tightening_threshold = 100;
            clamp.margin_top = 10;
            clamp.margin_bottom = 20;
            clamp.margin_start = 20;
            clamp.margin_end = 20;
            clamp.set_child (box);

            var headerbar = new Adw.HeaderBar();
            headerbar.add_css_class("flat");

            overlay = new Adw.ToastOverlay();
            overlay.set_child(clamp);

            var main_box = new Box (Orientation.VERTICAL, 0);
            main_box.append(headerbar);
            main_box.append(overlay);
            set_content(main_box);

            name_toast = new Adw.Toast(_("Enter the name of the site"));
            name_toast.set_timeout(3);
            keyword_toast = new Adw.Toast(_("Enter a keyword"));
            keyword_toast.set_timeout(3);
	}
		
		private void on_generate(){
            if(is_empty(entry_site.text)){
                overlay.add_toast(name_toast);
                entry_site.grab_focus();
                return;
            }
            if(is_empty(entry_key.text)){
                overlay.add_toast(keyword_toast);
                entry_key.grab_focus();
                return;
            }
		    try {
                  generated_pass.text = Crypto.derive_password(entry_key.text.strip(), entry_site.text.down().strip());
                } catch (CryptoError error) {
                    alert(_("ERROR!!!\nFailed to generate password"),"");
                }
		}
        private void on_copy(){
              var clipboard = Gdk.Display.get_default().get_clipboard();
              clipboard.set_text(generated_pass.get_text());
            }
        private bool is_empty(string str){
            return str.strip().length == 0;
        }

	private void alert (string heading, string body){
            var dialog_alert = new Adw.MessageDialog(this, heading, body);
            if (body != "") {
                dialog_alert.set_body(body);
            }
            dialog_alert.add_response("ok", _("_OK"));
            dialog_alert.set_response_appearance("ok", SUGGESTED);
            dialog_alert.response.connect((_) => { dialog_alert.close(); });
            dialog_alert.show();
        }
    }
}


