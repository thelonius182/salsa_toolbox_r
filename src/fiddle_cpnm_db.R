pacman::p_load(ssh, DBI, readr, processx, openssl)

# Start the SSH tunnel on local port 3307
tunnel <- processx::process$new(
  "ssh",
  args = c(
    "-i", "C:/Users/gergiev/.ssh/cpnm_test_lon", # RSA private key
    "-L", "3307:127.0.0.1:3306",                 # local:remote port mapping
    "forge@134.209.83.200",
    "-N"                                         # no remote command
  ),
  stdout = "|",  # optional, capture stdout
  stderr = "|"
)

# Check if the process is running
ta <- tunnel$is_alive()  # TRUE means tunnel is active

# get the database credentials, created using G:/R_proj_gergiev/released/salsa_toolbox_r/src/handle_credentials.R
cpnm_creds <- read_rds(file = "C:/Users/gergiev/cz_rds_store/cpnm_creds.RDS")
msg_dec <- aes_cbc_decrypt(cpnm_creds$msg_enc, key = cpnm_creds$key, iv = cpnm_creds$iv)

# Connect via tunnel (running on local port 3307)
con <- dbConnect(
  drv = RMySQL::MySQL(),
  host = "127.0.0.1",
  port = 3307,
  user = "forge",
  password = rawToChar(msg_dec),
  dbname = "test_cpnm_nl"
)

# ... run queries ...
query <- "SELECT distinct type FROM entries"
result <- dbGetQuery(con, query)

# Cleanup
dbd <- dbDisconnect(con)

# close the tunnel
tk <- tunnel$kill()
