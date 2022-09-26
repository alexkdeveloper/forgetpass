
using Gtk;

namespace Forgetpass {
	public class MainWindow : Adw.ApplicationWindow {
        private PasswordEntry generated_pass;
        private PasswordEntry entry_key;
        private Entry entry_site;
        private Adw.ToastOverlay overlay;
        private Adw.Toast name_toast;
        private Adw.Toast keyword_toast;

		public MainWindow (Adw.Application app) {
			Object (application: app, title: "Forgetpass", default_height: 250, default_width: 300);
		}

		construct {
			var label_site = new Label(_("Site:")) { 
                halign = Gtk.Align.START 
            };
            entry_site = new Entry() {
                hexpand = true
            };
            var entry_site_tooltip_image = new Image.from_icon_name("dialog-information-symbolic") { 
                halign = Gtk.Align.START, 
                tooltip_text = _("Use only the domain name without prefixes, such as http or www, and endings, such as .com, etc.") 
                };

            var label_key = new Label(_("Keyword:")) { 
                halign = Gtk.Align.START 
            };
            entry_key = new PasswordEntry() { 
                hexpand = true,
                show_peek_icon = true
            };
            var entry_key_tooltip_image = new Image.from_icon_name("dialog-information-symbolic") { 
                halign = Gtk.Align.START, 
                tooltip_text = _("Be sure to remember the keyword! If you forget it, you won't be able to recover your password!") 
                };
            var generate_button = new Button.with_label(_("GENERATE"));
            generated_pass = new PasswordEntry() { 
                show_peek_icon = true,
                editable = false
            };     

            generate_button.clicked.connect(on_generate);

            var hbox_site = new Box (Orientation.HORIZONTAL, 5);
            hbox_site.append (entry_site);
            hbox_site.append (entry_site_tooltip_image);
            var vbox_site = new Box (Orientation.VERTICAL, 5);
            vbox_site.append(label_site);
            vbox_site.append(hbox_site);

            var hbox_key = new Box (Orientation.HORIZONTAL, 5);
            hbox_key.append (entry_key);
            hbox_key.append (entry_key_tooltip_image);
            var vbox_key = new Box (Orientation.VERTICAL, 5);
            vbox_key.append(label_key);
            vbox_key.append(hbox_key);

            var box = new Box (Orientation.VERTICAL, 10);
            box.vexpand = true;
            box.append(vbox_site);
            box.append(vbox_key);
            box.append(generate_button);
            box.append(generated_pass);

            var clamp = new Adw.Clamp ();
            clamp.valign = Gtk.Align.CENTER;
            clamp.tightening_threshold = 100;
            clamp.margin_top = 10;
            clamp.margin_bottom = 20;
            clamp.margin_start = 20;
            clamp.margin_end = 20;
            clamp.set_child (box);

            var headerbar = new Adw.HeaderBar();

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


