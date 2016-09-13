# Postgresql 9.5 related attributes
default['postgresql']['version'] = '9.5'
default['chef-urbancode-server-pg-baseurl'] = "#{node['ynap']['artifactory']['url']}/postgresql-yum/"
default['postgresql']['client']['packages'] = ['postgresql95', 'postgresql95-devel', 'postgresql95-libs']
default['postgresql']['server']['packages'] = ['postgresql95-server']
default['postgresql']['server']['service_name'] = 'postgresql-9.5'
default['postgresql']['contrib']['packages'] = ['postgresql95-contrib']
default['postgresql']['setup_script'] = '/usr/pgsql-9.5/bin/postgresql95-setup'
