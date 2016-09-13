#
# Cookbook Name:: chef-postgresql-server
# Recipe:: default
#
# Copyright 2016, YooxLabs
#

log_prefix = "COOKBOOK:#{cookbook_name} RECIPE:#{recipe_name} - "

log "#{log_prefix}START"

log "#{log_prefix}Include relevant recipes"
include_recipe 'chef-postgresql-server::requires'
include_recipe 'chef-postgresql-server::setup'
include_recipe 'chef-postgresql-server::create_ibmucd_appdb'

log "#{log_prefix}END"
