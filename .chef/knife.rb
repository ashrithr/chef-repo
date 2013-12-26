current_dir = File.dirname(__FILE__)
user = ENV['OPSCODE_USER'] || ENV['USER']
orgname = ENV['ORGNAME'] || 'chef'
aws_ssh_key = ENV['AWS_SSH_KEY_ID'] || 'ankuscli'
log_level                :info
log_location             STDOUT
node_name                user
client_key               "#{ENV['HOME']}/.chef/#{user}.pem"
validation_client_name   "#{orgname}-validator"
validation_key           "#{ENV['HOME']}/.chef/#{orgname}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{orgname}"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID'] 
knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
knife[:aws_ssh_key_id] = aws_ssh_key
knife[:identity_file] = "#{ENV['HOME']}/.chef/#{aws_ssh_key}.pem"
knife[:region] = "eu-west-1"
knife[:availability_zone] = "eu-west-1a"
