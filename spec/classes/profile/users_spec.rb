# require 'spec_helper'

# describe 'profile::windows::activedirectory::users' do
#   context 'with default values for all parameters' do
#     let(:params) {{
#       :domain_administrator_password => 'Testing123!',
#     }}
#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::activedirectory::users') }

#     it { should contain_dsc_xaduser('ad_principal_manager').with({
#         :dsc_ensure      => 'present',
#         :dsc_domainname  => 'tragiccode.local',
#         :dsc_username    => 'ad_principal_manager',
#         :dsc_password => {
#           'user'     => 'this is ignored',
#           'password' => 'Testing123!',
#         },
#         :dsc_description => 'Managed by Puppet! Changes made manually may be lost.',
#     }) }

#   end
# end
