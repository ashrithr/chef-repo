Install Chef Client:

    gem install chef

Using Hosted Chef:
  Get credentials from your account:

    [your_organization_name]-validator.pem
    [your_username].pem
    knife.rb

Get the base chef structure from github:

    mkdir ~/Development
    git clone git://github.com/opscode/chef-repo ~/Development/chef-repo

Create .chef in base and copy credentials:

    mkdir ~/Development/chef-repo/.chef
    mv ~/Downloads/*.pem ~/Development/chef-repo/.chef/
    mv ~/Downloads/knife.rb ~/Development/chef-repo/.chef/

Base line knife.rb

    current_dir = File.dirname(__FILE__)
    user = ENV['OPSCODE_USER'] || ENV['USER']
    orgname = ENV['ORGNAME'] || 'cloudwicktech'
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

Basic commands:

1. Verify the credentials:

        knife client list

2. To download community cookbooks:

        knife cookbook site install <cookbook_name>
        ex: knife cookbook site install apt

3. Create a cookbook structure

        knife cookbook create aliases
        knife cookbook create_specs aliases                         # creates test specs for cookbook specified

4. Upload cookbooks

        knife cookbook upload -a
        knife cookbook upload -o <cookbooks_dirname> --all

5. Install roles on chef-server

        knife role from file roles/*.rb

6. Install environments & nodes on chef-server from workstation

        knife environment from file <env>.json
        knife node from file "path to JSON file" #from file argument is used to create a node using existing node data as a template.

5. Delete all cookbooks hosted on server

        knife cookbook bulk delete '.*'

Creating Base node:

1. Create a node using `vagrant`

        vagrant init opscode-ubuntu-1204 https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04-i386_chef-11.4.4.box --no-color

        vagrant up --no-color

2. Bootstrap a vagrant node

        knife bootstrap IP_ADDRESS -x ubuntu -i ~/.ssh/id_rsa --sudo

        knife bootstrap localhost \
        --ssh-user vagrant \
        --ssh-password vagrant \
        --ssh-port 2222 \
        --run-list "recipe[apt],recipe[aliases],recipe[apache2],recipe[networking_basic]" \
        --sudo

3. Verify changes by logging into server and check if the recipes were applied manually

        vagrant ssh

4. Get node info and verify changes

        knife node show FQDN
        knife node show FQDN -r #to just see the runlist

5. Deleting node on vagrant and chef server:

        vagrant destroy
        knife node delete FQDN
        knife client delete FQDN

6. Edit node information including run list:

        knife node edit FQDN -a

7. Edit runlist of a node:

        knife node run_list add NODE 'role[ROLE_NAME]'
        ex: knife node run_list add FQDN 'recipe[COOKBOOK::RECIPE_NAME],COOKBOOK::RECIPE_NAME,role[ROLE_NAME]'

8. Remove runlist of a node:

        knife node run_list remove FQDN 'recipe[COOKBOOK::RECIPE_NAME]'

9. Re-Run chef client with recipe ntp:

        knife bootstrap FQDN -x USERNAME --sudo -r 'recipe[ntp]'
        (or)
        knife ssh 'name:webserver01' 'sudo chef-client'

        # run chef client on the new node using ssh
        knife ssh name:NODENAME -x ubuntu -P PASSWORD "sudo chef-client"

10. Run chef client on all machines using ssh:

        knife ssh 'name:*' 'sudo chef-client'

Using Chef Solo (for development):

chef-solo is a standalone version of chef client which does not rely on chef server for configuration

1. Install chef-solo

        gem install chef

2. Create a configuration for chef-solo (default: /etc/chef/solo.rb) and copy the below contents, which specifies chef-solo to where to find the cookbooks

        cookbook_path "/cookbooks"

3. Run chef-solo using:

        chef-solo

4. To add runlist to a chef-solo: (default: /etc/chef/node.json)

        {
            "run_list": ["recipe[nginx]"]
        }

5. Run chef-solo with runlist:

        chef-solo -j /etc/chef/node.json