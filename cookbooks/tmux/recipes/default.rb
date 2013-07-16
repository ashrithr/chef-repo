#
# Cookbook Name:: tmux
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Install the tmux package
package 'tmux'

#Drop the tmux configuration template
template "/etc/tmux.conf" do
  source "tmux.conf.erb"
  mode 00644
end
