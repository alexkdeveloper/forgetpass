
public class ForgetPass : Adw.Application {
    public ForgetPass () {
        Object (
            application_id: "com.github.alexkdeveloper.forgetpass",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Forgetpass.MainWindow (this);
        }
        win.present ();
    }
}

int main (string[] args) {
    Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
    Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
    Intl.textdomain (Config.GETTEXT_PACKAGE);
    var app = new ForgetPass ();
    return app.run (args);
}
