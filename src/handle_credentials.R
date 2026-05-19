pacman::p_load(sodium)

# Your password
password <- "mySecretPassword"

# Generate a random key (keep this secret)
key <- bin2hex(random(32))

# Encrypt the password
password_bytes <- charToRaw(password)
encrypted <- simple_encrypt(password_bytes, key = hex2bin(key))

# Decrypt
decrypted <- rawToChar(simple_decrypt(encrypted, key = hex2bin(key)))

encrypted
decrypted  # Should return "mySecretPassword"
