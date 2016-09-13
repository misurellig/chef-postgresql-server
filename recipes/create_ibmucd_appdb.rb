#
# Cookbook Name:: chef-postgresql-server
# Recipe:: create_ibmucd_appdb
#
# Copyright 2016, YooxLabs
#

log_prefix = "COOKBOOK:#{cookbook_name} RECIPE:#{recipe_name} - "

log "#{log_prefix}START"

# Searching over databag and assign node defaults
databag = search('private_users_credentials', 'id:chef_urbancode').first.to_hash[node.chef_environment]['pg_credentials']
node.default['chef-urbancode-server']['postgres-db-name'] = databag['pg_admin']['database']
node.default['chef-urbancode-server']['postgres-db-user'] = databag['pg_admin']['username']
node.default['chef-urbancode-server']['postgres-db-password'] = databag['pg_admin']['password']
node.default['chef-urbancode-server']['urbancode-db-name'] = databag['pg_app']['database']
node.default['chef-urbancode-server']['urbancode-db-username'] = databag['pg_app']['username']
node.default['chef-urbancode-server']['urbancode-db-password'] = databag['pg_app']['password']

node.default['postgresql']['pg_hba'] = [
  { type: 'local',
    db: 'all',
    user: node['chef-urbancode-server']['postgres-db-user'],
    addr: nil,
    method: 'ident'
  },
  { type: 'host',
    db: 'all',
    user: node['chef-urbancode-server']['postgres-db-user'],
    addr: 'samehost',
    method: 'md5'
  },
  { type: 'host',
    db: node['chef-urbancode-server']['urbancode-db-name'],
    user: node['chef-urbancode-server']['urbancode-db-username'],
    addr: 'samehost',
    method: 'md5'
  }
]

# Create postgres user pass
log "#{log_prefix}Create #{node['chef-urbancode-server']['postgres-db-user']} user pass"
bash 'assign-postgres-password' do
  user 'postgres'
  code <<-EOH
  psql -c "ALTER ROLE #{node['chef-urbancode-server']['postgres-db-name']} PASSWORD \'#{node['chef-urbancode-server']['postgres-db-password']}\';"
  EOH
  action :run
  not_if "ls #{node['postgresql']['config']['data_directory']}/recovery.conf"
end

# Using database cookbook resources
pg_connection_info = {
  host: node['postgresql']['config']['listen_addresses'],
  port: node['postgresql']['config']['port'],
  username: node['chef-urbancode-server']['postgres-db-user'],
  password: node['chef-urbancode-server']['postgres-db-password']
}

# Create urban code db
log "#{log_prefix}Create #{node['chef-urbancode-server']['urbancode-db-name']} database"
postgresql_database node['chef-urbancode-server']['urbancode-db-name'] do
  connection pg_connection_info
  action :create
end

# Create urban database user and grant privileges
log "#{log_prefix}Create #{node['chef-urbancode-server']['urbancode-db-username']} and grant privileges"
postgresql_database_user node['chef-urbancode-server']['urbancode-db-username'] do
  connection pg_connection_info
  password node['chef-urbancode-server']['urbancode-db-password']
  database_name node['chef-urbancode-server']['urbancode-db-username']
  privileges [:all]
  action [:create, :grant]
end

log "#{log_prefix}END"
