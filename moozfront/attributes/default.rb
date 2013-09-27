default[:moozfront][:elasticsearch_elb] = nil
default[:moozfront][:force_deps] = false 
override[:deploy][:moozfront][:symlink_before_migrate] = {"erlasticsearch.config" => "erlasticsearch.config", 'boss' => "boss"}