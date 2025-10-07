# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# USAGE: in a terminal run this cmd
#        G:\R_proj_gergiev\released\salsa_toolbox_r>Rscript ./src/handle_credentials.R -p <the password>
# This will store the encrypted password (cyphertext) in C:/Users/gergiev/cz_rds_store/cpnm_creds.RDS, along
# with the key and nonce needed to decrypt it.
#
# To use the plaintext pwd in a script, see e.g. here:
#        G:/R_proj_gergiev/released/salsa_toolbox_r/src/fiddle_cpnm_db.R
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
pacman::p_load(openssl, optparse, readr)

# Define the options
moro_options <- list(
  make_option(c("-p", "--password"), type = "character", default = NULL,
              help = "the password to be encrypted", metavar = "character")
)

# Parse the command-line arguments
opt_parser <- OptionParser(option_list = moro_options)
opts <- parse_args(opt_parser)

# Check if required arguments are provided
if (is.null(opts$password)) {
  stop("missing argument(s). Please provide the password, using '-p' or '--password'.", call. = FALSE)
}

# one-time set up
key <- rand_bytes(32)  # 256-bit key
iv  <- rand_bytes(16)
msg <- charToRaw(opts$password)
msg_enc <- aes_cbc_encrypt(msg, key = key, iv = iv)
write_rds(list(key = key, iv = iv, msg_enc = msg_enc), file = "C:/Users/gergiev/cz_rds_store/cpnm_creds.RDS")

# validate
cpnm_creds <- read_rds(file = "C:/Users/gergiev/cz_rds_store/cpnm_creds.RDS")
msg_dec <- aes_cbc_decrypt(cpnm_creds$msg_enc, key = cpnm_creds$key, iv = cpnm_creds$iv)
rawToChar(msg_dec)

