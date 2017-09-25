# require 'spec_helper'

# describe 'profile::windows::activedirectory::dnsserver' do
#   context 'with default values for all parameters' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :networking => { 'network' => '10.43.202.0', },
#     }}
#     # let(:params) {{
#     #   :domain_name                      => 'tragiccode.local',
#     #   :domain_net_bios_name             => 'TRAGICCODE',
#     #   :safe_mode_administrator_password => 'TestPassword123!',
#     #   :domain_administrator_user        => 'bobdole',
#     #   :domain_administrator_password    => 'TestPassword321@',
#     #   :is_first_dc                      => true,
#     # }}
#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::activedirectory::dnsserver') }

#     it { should contain_dsc_xdnsserveradzone('Ipv4 Reverse Lookup Zone').with({
#         :dsc_ensure           => 'present',
#         :dsc_name             => '202.43.10.in-addr.arpa',
#         :dsc_replicationscope => 'Forest',
#         :dsc_dynamicupdate    => 'None',
#     }) }

#     it { should contain_dsc_xdnsserveradzone('Forward Lookup Zone').with({
#         :dsc_ensure           => 'present',
#         :dsc_name             => 'tragiccode.local',
#         :dsc_replicationscope => 'Forest',
#         :dsc_dynamicupdate    => 'Secure',
#     }) }

#   end

# end
