# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Task Scheduler → PowerShell wrapper → Rscript → Workspace SMTP relay → alert email
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

library(blastula)
library(keyring)

smtp_user <- "r-alerts@concertzender.nl"

email <- compose_email(
  body = md("
Test message from R via Google Workspace SMTP relay.
Now courtesy Task Scheduler!!
If this arrived again, the SMTP relay still works.
")
)

smtp_send(
  email = email,
  from = smtp_user,
  to = "cz.teamservice@concertzender.nl",
  subject = "Test: R authenticated SMTP relay alert",
  credentials = creds_key("gmailrelay")
)
