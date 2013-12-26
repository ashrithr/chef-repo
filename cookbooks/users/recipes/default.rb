#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# sample run_list.json
# to generate a showd'wed password use `openssl passwd -1 PASSWORD`
#
# {
#   "run_list": ['users']
#   'users': {
#     'ashrith': {
#       'ssh_keys': { 'mypublickey': 'a_long_key_value' },
#       'password': '$1$I1yQ7Mob$ux6wxDtO/FYOg/0dQzypC.'
#     }
#   }
# }
#
require_recipe 'ruby_shadow'

# node contains attributes from run_list, automatic attributes (ohai generated)
# node is a ruby mash, so can be accessed as hash or using syntactical sugar like node.users
node[:users].each do |name, conf|
  home_dir = "/home/#{name}"

  user name do
    password conf[:password]
    action [:create]
  end

  directory home_dir do
    owner name
    group name
    mode 0700
  end

  directory "#{home_dir}/.ssh" do
    owner name
    group name
    mode 0700
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    owner name
    mode 0600
    variables :keys => conf[:ssh_keys]
  end
end