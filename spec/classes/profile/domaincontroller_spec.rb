# require 'spec_helper'

# describe 'profile::windows::activedirectory::domaincontroller' do
#   context 'with default values for all parameters' do

#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) { {
#         :networking => { 'ip' => '10.0.2.15', 'primary' => 'Ethernet', },
#     } }

#     let(:params) {{
#       :domain_name                      => 'tragiccode.local',
#       :domain_net_bios_name             => 'TRAGICCODE',
#       :safe_mode_administrator_password => 'TestPassword123!',
#       :domain_administrator_user        => 'bobdole',
#       :domain_administrator_password    => 'TestPassword321@',
#       :is_first_dc                      => true,
#     }}
#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::activedirectory::domaincontroller') }

#     it { should contain_dsc_windowsfeature('RSAT-ADDS').with({
#         :dsc_ensure => 'present',
#         :dsc_name   => 'RSAT-ADDS',
#     }) }

#     it { should contain_dsc_windowsfeature('AD-Domain-Services').with({
#         :dsc_ensure => 'present',
#         :dsc_name   => 'AD-Domain-Services',
#     }) }

#     it { should contain_dsc_xaddomain('tragiccode.local').with({
#         :ensure                            => 'present',
#         :dsc_domainname                    => 'tragiccode.local',
#         :dsc_domainnetbiosname             => 'TRAGICCODE',
#         :dsc_safemodeadministratorpassword => {
#             'user'     => 'this is ignored',
#             'password' => 'TestPassword123!',
#         },
#         :dsc_domainadministratorcredential => {
#             'user'     => 'bobdole',
#             'password' => 'TestPassword321@',
#         },
#         :dsc_databasepath                  => 'C:\\Windows\\NTDS',
#         :dsc_logpath                       => 'C:\\Windows\\NTDS',
#         :dsc_sysvolpath                    => 'C:\\Windows\\SYSVOL',
#         :require                           => 'Dsc_windowsfeature[AD-Domain-Services]',
#         :notify                            => 'Reboot[new_domain_controller_reboot]',
#     }) }

#     it { should_not contain_dsc_xaddomaincontroller('Additional Domain Controller') }

#     it { should contain_reboot('new_domain_controller_reboot').with(
#         :message => 'New domain controller installed and is causing a reboot since one is pending',
#         :apply   => 'immediately',
#     ) }

#     it { should contain_dsc_xdnsserveraddress('DnsServerAddresses').with({
#         :ensure             => 'present',
#         :dsc_address        => [ '10.0.2.15' ],
#         :dsc_interfacealias => 'Ethernet',
#         :dsc_addressfamily  => 'IPv4',
#         :dsc_validate       => true,
#     })}

#   end

#     context 'with is_first_dc => false' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) { {
#         :networking => { 'ip' => '10.0.2.15', 'primary' => 'Ethernet', },
#     } }

#     let(:params) {{
#       :domain_name                      => 'tragiccode.local',
#       :domain_net_bios_name             => 'TRAGICCODE',
#       :safe_mode_administrator_password => 'TestPassword123!',
#       :domain_administrator_user        => 'bobdole',
#       :domain_administrator_password    => 'TestPassword321@',
#       :is_first_dc                      => false,
#       :first_dc_internal_ipv4_address   => '10.0.2.10'
#     }}
#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::windows::activedirectory::domaincontroller') }

#     it { should contain_dsc_windowsfeature('RSAT-ADDS').with({
#         :dsc_ensure => 'present',
#         :dsc_name   => 'RSAT-ADDS',
#     }) }

#     it { should contain_dsc_windowsfeature('AD-Domain-Services').with({
#         :dsc_ensure => 'present',
#         :dsc_name   => 'AD-Domain-Services',
#     }) }

#     it { should_not contain_dsc_xaddomain('tragiccode.local') }

#     it { should contain_dsc_xaddomaincontroller('Additional Domain Controller').with({
#         :dsc_domainname                    => 'tragiccode.local',
#         :dsc_safemodeadministratorpassword => {
#             'user'     => 'this is ignored',
#             'password' => 'TestPassword123!',
#         },
#         :dsc_domainadministratorcredential => {
#             'user'     => 'bobdole',
#             'password' => 'TestPassword321@',
#         },
#         :dsc_databasepath                  => 'C:\\Windows\\NTDS',
#         :dsc_logpath                       => 'C:\\Windows\\NTDS',
#         :dsc_sysvolpath                    => 'C:\\Windows\\SYSVOL',
#         :require                           => 'Dsc_windowsfeature[AD-Domain-Services]',
#         :notify                            => 'Reboot[new_domain_controller_reboot]',
#     }) }

#     it { should contain_reboot('new_domain_controller_reboot').with(
#         :message => 'New domain controller installed and is causing a reboot since one is pending',
#         :apply   => 'immediately',
#     ) }

#     it { should contain_dsc_xdnsserveraddress('DnsServerAddresses').with({
#         :ensure             => 'present',
#         :dsc_address        => [ '10.0.2.10' ],
#         :dsc_interfacealias => 'Ethernet',
#         :dsc_addressfamily  => 'IPv4',
#         :dsc_validate       => true,
#     })}

#   end
# end
