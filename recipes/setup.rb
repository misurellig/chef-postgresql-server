#
# Cookbook Name:: chef-postgresql-server
# Recipe:: setup
#
# Copyright 2016, YooxLabs
#

log_prefix = "COOKBOOK:#{cookbook_name} RECIPE:#{recipe_name} - "

log "#{log_prefix}START"

node.default['build_essential']['compile_time'] = true

# Create postgres user at compile time
log "#{log_prefix}Create PostgreSQL user"
user 'postgres' do
  comment 'PostgreSQL Server'
  action :nothing
end.run_action(:create)

# Create artifactory repo at compile time
log "#{log_prefix}Create PostgreSQL local repo"
yum_repository 'artifactory-pg' do
  description 'Artifactory Postgresql'
  gpgcheck false
  baseurl node['chef-urbancode-server-pg-baseurl']
  action :nothing
end.run_action(:create)

# PostgreSQL server recipe inclusion
include_recipe 'postgresql::server'

# PostgreSQL ruby recipe inclusion
include_recipe 'postgresql::ruby'

log "#{log_prefix}END"
