# require 'spec_helper'

# describe 'profile::windows::sqlserver' do
#   context 'with default values for all parameters' do

#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::sqlserver') }

#     it { should contain_dsc_xsqlserversetup('Install SQL Server').with({
#         :ensure      => 'present',
#     }) }

#     it { should contain_service('MSSQLSERVER').with({
#       :ensure => 'running',
#       :enable => true,
#     })}

#   end
# end
