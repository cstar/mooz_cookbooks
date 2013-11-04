node[:deploy].each do |application, deploy|
  next if not node[:opsworks][:instance][:layers].include? application 
  node[:bulkimporter][:feed_sources].each do |source|
    template "#{deploy[:deploy_to]}/current/import_#{source[:importer]}" do
      mode 0755
      source "import_all.erb"
      group deploy[:group]
      owner deploy[:user]
      variables :source => source,
                :data_path => "#{deploy[:deploy_to]}/shared/data",
                :app_path => "#{deploy[:deploy_to]}/current"
    end
    cron "cron for #{source[:importer]}" do
      action :create
      minute  source[:minutes] || "0"
      hour    source[:hours] || "6"
      home    "#{deploy[:deploy_to]}/current"
      user    deploy[:user]
      mailto  node[:bulkimporter][:mailto]
      command "./import_#{source[:importer]}"
    end
  end
end