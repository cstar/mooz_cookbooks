default[:moozfront][:elasticsearch_elb] = "localhost"
default[:moozfront][:force_deps] = false 
default[:moozfront][:cookie] = "changeme" 
default[:moozfront][:mail_driver] = "boss_mail_driver_smtp"
default[:moozfront][:mail_relay_host] = nil
default[:moozfront][:mail_relay_user] = nil
default[:moozfront][:mail_relay_password] = nil


default[:bulkimporter][:feed_sources] = []
default[:bulkimporter][:static_bucket] = ""
default[:bulkimporter][:static_datasources] = []
default[:bulkimporter][:mailto] = ""
