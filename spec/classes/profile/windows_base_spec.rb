# require 'spec_helper'

# describe 'profile::windows::base' do

#   context 'with default values for all parameters' do

#     let(:facts) {
#         {
#           :chocolateyversion  => '0.9.8.33',
#           :choco_install_path => 'C:\ProgramData\chocolatey',
#         }
#     }

#     it { should contain_class('profile::windows::base') }

#     it { should contain_class('chocolatey').with({
#       :chocolatey_version => '0.10.6.1',
#       :log_output         => true,
#     }) }

#     it { should contain_dsc_xtimezone('Server Timezone').with({
#         :ensure               => 'present',
#         :dsc_issingleinstance => 'yes',
#         :dsc_timezone         => 'UTC',
#     }) }

#   end
# end
