
 public errordomain CryptoError {
    DERIVATION_FAILED
}

public class Crypto {
    public static string derive_password (string cipher_key, string salt) throws CryptoError {
        var keybuffer = new uint8[16];

        const char[] ALLOWED_CHARS = {
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
            'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
            'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
            '!', '#', '$', '%', '&', '(', ')', '*', '+', '-', ';', '<', '=',
            '>', '?', '@', '^', '_', '`', '{', '|', '}', '~'
        };

        var error = GCrypt.KeyDerivation.derive (
            cipher_key.data,
            GCrypt.KeyDerivation.Algorithm.PBKDF2,
            GCrypt.Hash.Algorithm.SHA256,
            salt.data,
            10000,
            keybuffer
        );

        if (error.code () != GCrypt.ErrorCode.NO_ERROR) {
            throw new CryptoError.DERIVATION_FAILED (error.to_string ());
        }

        var derived_characters = new StringBuilder.sized (keybuffer.length);

        for (ushort index = 0; index < keybuffer.length; index++) {
            var character = ALLOWED_CHARS[keybuffer[index] % ALLOWED_CHARS.length];
            derived_characters.append_c (character);
        }

        return derived_characters.str;
    }
}
