# require 'spec_helper'

# describe 'profile::windows::ravendb' do
#   context 'with default values for all parameters' do

#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::ravendb') }

#     it { should contain_class('ravendb').with({
#         :package_ensure                         => 'present',
#         :ravendb_service_name                   => 'RavenDB',
#         :ravendb_port                           => 8080,
#         :ravendb_target_environment             => 'development',
#         :ravendb_database_directory             => 'C:\\RavenDB\\Databases',
#         :ravendb_filesystems_database_directory => 'C:\\RavenDB\\FileSystems',
#         :service_ensure                         => 'running',
#         :service_enable                         => true,
#     }) }

#   end
# end
