require 'spec_helper'

pg_version = 'postgresql95'
pg_port = '5432'

pg_client_pkgs = [pg_version, "#{pg_version}-libs", "#{pg_version}-devel"]
pg_server_pkgs = ["#{pg_version}-server"]
pg_service = 'postgresql-9.5'

describe 'chef-urbancode-server::create_databse' do
  describe yumrepo('pgdg95') do
    it { should exist }
    it { should be_enabled }
  end

  describe 'PostgreSQL database creation' do
    context 'client packages installation' do
      pg_client_pkgs.each do |pkg|
        describe package(pkg) do
          it { should be_installed }
        end
      end
    end

    context 'server configurations' do
      pg_server_pkgs.each do |pkg|
        describe package(pkg) do
          it { should be_installed }
        end
      end
      describe service(pg_service) do
        it { should be_running.under('systemd') }
      end
      describe port(pg_port) do
        it { should be_listening.with('tcp') }
      end
    end
  end
end
