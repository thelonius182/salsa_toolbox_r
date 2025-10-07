library(futile.logger)

fa <- flog.appender(appender.file("/Users/nipper/Logs/wp_speed_update.log"), name = "wsu_log")
flog.info("wordpress speed-update", name = "wsu_log")
