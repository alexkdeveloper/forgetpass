
using Gtk;

namespace Forgetpass {
	public class MainWindow : Adw.ApplicationWindow {
        private PasswordEntry generated_pass;
        private PasswordEntry entry_key;
        private Entry entry_site;
		public MainWindow (Gtk.Application app) {
			Object (application: app, title: "Forgetpass", default_height: 250, default_width: 300);
		}
		construct {
            
			var label_site = new Label("Site:") { 
                halign = Gtk.Align.START 
            };
            entry_site = new Entry() {
                hexpand = true
            };
            var entry_site_tooltip_image = new Image.from_icon_name("dialog-information-symbolic") { 
                halign = Gtk.Align.START, 
                tooltip_text = "Use only the domain name without prefixes, such as http or www, and endings, such as .com, etc." 
                };

            var label_key = new Label("Keyword:") { 
                halign = Gtk.Align.START 
            };
            entry_key = new PasswordEntry() { 
                hexpand = true,
                show_peek_icon = true
            };
            var entry_key_tooltip_image = new Image.from_icon_name("dialog-information-symbolic") { 
                halign = Gtk.Align.START, 
                tooltip_text = "Be sure to remember the keyword! If you forget it, you won't be able to recover your password!" 
                };
            var generate_button = new Button.with_label("GENERATE");
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
            box.set_margin_bottom(6);
            box.set_margin_top(6);
            box.set_margin_end(6);
            box.set_margin_start(6);
            box.append(vbox_site);
            box.append(vbox_key);
            box.append(generate_button);
            box.append(generated_pass);

            var headerbar = new Adw.HeaderBar();

            var main_box = new Box (Orientation.VERTICAL, 0);
            main_box.append(headerbar);
            main_box.append(box);
            set_content(main_box);
		}
		
		private void on_generate(){
            if(is_empty(entry_site.text)){
                alert("Enter the name of the site");
                entry_site.grab_focus();
                return;
            }
            if(is_empty(entry_key.text)){
                alert("Enter a keyword");
                entry_key.grab_focus();
                return;
            }
		    try {
                  generated_pass.text = Crypto.derive_password(entry_key.text.strip(), entry_site.text.down().strip());
                } catch (CryptoError error) {
                    alert("ERROR!!!\nFailed to generate password");
                }
		}

        private bool is_empty(string str){
            return str.strip().length == 0;
        }

		private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title("Message");
          dialog_alert.response.connect((_) => { dialog_alert.close(); });
          dialog_alert.show();
       }
	}
}


