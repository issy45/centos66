#ruby関連？ruby入れるのに使う
%w(gcc openssl-devel readline-devel git libxml2-devel libxslt-devel libffi-devel).each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/#{node['ruby-env']['user']}/.rbenv" do
  repository node['ruby-env']['rbenv_url']
  reference 'master'
  action :sync
  group node['ruby-env']['group']
  user node['ruby-env']['user']
end

# bash_profileが他のレシピでも変更されている場合は、このやり方だとダメ
template '.bash_profile' do
  source 'bash_profile.erb'
  path "/home/#{node['ruby-env']['user']}/.bash_profile"
  mode '0644'
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if "grep rbenv /home/#{node['ruby-env']['user']}/.bash_profile"
end

directory "/home/#{node['ruby-env']['user']}/.rbenv/plugins" do
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  mode '0755'
  action :create
end

%w(ruby-build rbenv-default-gems rbenv-gem-rehash).each do |plgin|
  git "/home/#{node['ruby-env']['user']}/.rbenv/plugins/#{plgin}" do
    repository node['ruby-env']["#{plgin}_url"]
    reference 'master'
    action :sync
    group node['ruby-env']['group']
    user node['ruby-env']['user']
  end
end

template 'default-gems' do
  source 'default-gems.erb'
  path "/home/#{node['ruby-env']['user']}/.rbenv/default-gems"
  mode '0755'
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/default-gems") }
end

execute "rbenv install #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv install #{node['ruby-env']['version']}"
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  user node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/versions/#{node['ruby-env']['version']}") }
end

execute "rbenv global #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv global #{node['ruby-env']['version']}"
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  user node['ruby-env']['user']
  group node['ruby-env']['group']
  not_if "grep #{node['ruby-env']['version']} /home/#{node['ruby-env']['user']}/.rbenv/version"
end

# これないとRailsのinstallが途中で止まる
execute "resolv.option" do
  not_if "grep 'options single-request-reopen' /etc/resolv.conf"
  command "echo 'options single-request-reopen' >> /etc/resolv.conf"
  action :run
end

#-------------------
# Railsのインストール
#-------------------

# nokogiriにはこのオプションが必要
gem_package "nokogiri" do
  gem_binary "/home/#{node['ruby-env']['user']}/.rbenv/shims/gem"
  action :install
  options "-- --use-system-libraries"
end

%w(atomic rails passenger).each do |pkg|
  gem_package pkg do
    gem_binary "/home/#{node['ruby-env']['user']}/.rbenv/shims/gem"
    action :install
  end
end