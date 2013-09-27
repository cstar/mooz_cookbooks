default[:moozfront][:elasticsearch_elb] = nil
default[:moozfront][:force_deps] = false 
node[:deploy][:moozfront][:symlink_before_migrate] = {"erlasticsearch.config" => "erlasticsearch.config", 'boss' => "boss"}