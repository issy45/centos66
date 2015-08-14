service 'httpd' do
  supports :stop => true, :start => true, :restart => true
  action [ :enable, :restart ]
end