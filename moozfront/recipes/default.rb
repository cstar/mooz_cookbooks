include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  next if not node[:opsworks][:instance][:layers].include? application

  opsworks_deploy_user do
    deploy_data deploy
  end

  directory "#{deploy[:deploy_to]}/shared" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    action :create
    recursive true
  end


  # create shared/ directory structure
  ['log','deps', 'ebin'].each do |dir_name|
    directory "#{deploy[:deploy_to]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode 0775
      action :create
      recursive true
    end
  end

  template "#{deploy[:deploy_to]}/shared/erlasticsearch.config" do
    source "erlasticsearch.config.erb"
    group deploy[:group]
    owner deploy[:user]
    variables :erlasticsearch_elb => node[:moozfront][:erlasticsearch_elb]
  end



  opsworks_deploy do
    deploy_data deploy
    app application
  end

  ['ebin','deps'].each do |dir_name|
    link "#{deploy[:deploy_to]}/current/#{dir_name}" do
      target_file "#{deploy[:deploy_to]}/current/#{dir_name}"
      to "#{deploy[:deploy_to]}/shared/#{dir_name}"
      group deploy[:group]
      owner deploy[:user]
    end
  end

  template "#{deploy[:deploy_to]}/current/init.sh" do
    source "init.sh.erb"
    group deploy[:group]
    owner deploy[:user]
    variables :hostname => node[:opsworks][:instance][:hostname]
              :application => application
              :deploy_path => deploy[:deploy_to]
  end


  if node[:moozfront][:force_deps] == true
    execute "remove deps" do
      command "rm -Rf *"
      cwd "#{deploy[:deploy_to]}/shared/deps"
      user deploy[:user]
    end
    execute "fetch deps" do
      command "./rebar get-deps compile"
      cwd "#{deploy[:deploy_to]}/current"
      user deploy[:user]
    end
  end

  execute "fetch deps" do
    command "./rebar compile skip_deps=true"
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
  end

  execute "restart server" do
    command "./init.sh restart"
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
  end
end