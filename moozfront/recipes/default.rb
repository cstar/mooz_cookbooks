include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  directory "#{params[:path]}/shared" do
    group deploy[:group]
    owner deploy[:user]
    mode 0770
    action :create
    recursive true
  end

  # create shared/ directory structure
  ['log','deps'].each do |dir_name|
    directory "#{params[:path]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode 0770
      action :create
      recursive true
    end
  end

  template "#{node[:deploy][application][:deploy_to]}/shared/erlasticsearch.config" do
    source "erlasticsearch.config.erb"
    variables :erlasticsearch_elb => node[:moozfront][:erlasticsearch_elb]
  end

  deploy[:symlink_before_migrate] = {"erlasticsearch.config" => "erlasticsearch.config"}
  opsworks_deploy do
    deploy_data deploy
    app application
  end



end