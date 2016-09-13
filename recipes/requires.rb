#
# Cookbook Name:: chef-postgresql-server
# Recipe:: requires
#
# Copyright 2016, YooxLabs
#

log_prefix = "COOKBOOK:#{cookbook_name} RECIPE:#{recipe_name} - "

log "#{log_prefix}START"

if ENV['debug_on']
  chef_gem 'pry' do
    action :install
  end
end

log "#{log_prefix}END"
