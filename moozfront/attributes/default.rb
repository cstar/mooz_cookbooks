default[:moozfront][:elasticsearch_elb] = nil
default[:deploy][:moozfront][:symlink_before_migrate] = {"erlasticsearch.config" => "erlasticsearch.config", "log" => "log", "deps" => "deps"}