deploy_path = "/srv/www/bulkimporter"
if node[:opsworks][:instance][:layers].include? "bulkimporter" 
  if node[:bulkimporter][:zanox]
    cron "cron for Zanox" do
      action :create
      minute  node[:bulkimporter][:zanox][:minutes] || "0"
      hour    node[:bulkimporter][:zanox][:hours] || "6"
      home    "#{deploy_path}/current"
      user    "deploy"
      mailto  node[:bulkimporter][:mailto]
      command "cd #{deploy_path}/current && ./zanox_import.sh"
    end
  end
  node[:bulkimporter][:feed_sources].each do |source|
    template "#{deploy_path}/current/import_#{source[:importer]}" do
      mode 0755
      source "import_all.erb"
      group "www-data"
      owner "deploy"
      variables :source => source,
                :data_path => "#{deploy_path}/shared/data",
                :app_path => "#{deploy_path}/current"
    end
    cron "cron for #{source[:importer]}" do
      action :create
      minute  source[:minutes] || "0"
      hour    source[:hours] || "6"
      home    "#{deploy_path}/current"
      user    "deploy"
      mailto  node[:bulkimporter][:mailto]
      command "cd #{deploy_path}/current &&  ./import_#{source[:importer]}"
    end
  end
end