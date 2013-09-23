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
  ['log','deps', "ebin"].each do |dir_name|
    directory "#{deploy[:deploy_to]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode 0770
      action :create
      recursive true
    end
  end

  template "#{deploy[:deploy_to]}/shared/erlasticsearch.config" do
    source "erlasticsearch.config.erb"
    variables :erlasticsearch_elb => node[:moozfront][:erlasticsearch_elb]
  end



  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "fetch deps" do
    command "./rebar get-deps compile"
    cwd "#{deploy[:deploy_to]}/current"
  end

  execute "restart server" do
    command "./init.sh restart"
    cwd "#{deploy[:deploy_to]}/current"
  end
end