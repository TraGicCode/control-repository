# require 'spec_helper'

# describe 'profile::windows::activedirectory::groups' do
#   context 'with default values for all parameters' do

#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::activedirectory::groups') }

#     it { should contain_dsc_xadgroup('Domain Admins').with({
#         :dsc_ensure           => 'present',
#         :dsc_groupname        => 'Domain Admins',
#         :dsc_memberstoinclude => ['ad_principal_manager'],
#         :dsc_category         => 'Security',
#         :dsc_groupscope       => 'Global',
#         :dsc_description      => 'Managed by Puppet! Changes made manually may be lost.',
#     }) }

#   end
# end
