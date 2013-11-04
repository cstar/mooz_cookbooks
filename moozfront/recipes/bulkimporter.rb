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
  ['log','deps', 'ebin', "data"].each do |dir_name|
    directory "#{deploy[:deploy_to]}/shared/#{dir_name}" do
      group deploy[:group]
      owner deploy[:user]
      mode 0775
      action :create
      recursive true
    end
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
  link "#{deploy[:deploy_to]}/current/priv/sample" do
      target_file "#{deploy[:deploy_to]}/current/priv/sample"
      to "#{deploy[:deploy_to]}/shared/data"
      group deploy[:group]
      owner deploy[:user]
    end


  template "#{deploy[:deploy_to]}/current/sys.config" do
    mode 0755
    source "sys.config.erb"
    group deploy[:group]
    owner deploy[:user]
    variables :app => node[:moozfront]
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


  execute "compile app" do
    command "./rebar compile skip_deps=true"
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
  end



  node[:bulkimporter][:static_datasources].each do |file|
    s3_file "#{deploy[:deploy_to]}/shared/data/#{file}" do
      remote_path file
      bucket node[:bulkimporter][:static_bucket]
      owner deploy[:user]
      group deploy[:group]
      mode "0644"
      action :create
    end
  end
  


end
