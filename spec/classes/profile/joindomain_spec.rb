# require 'spec_helper'

# describe 'profile::windows::activedirectory::joindomain' do

#   context 'with default values for all parameters' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :hostname   => 'g-x-00-wi-windows001',
#     }}

#     let(:params) {{
#         :domain_name          => 'tragiccode.local',
#         :domain_join_username => 'bobdole',
#         :domain_join_password => 'Password123!',
#         :domain_join_ou       => 'OU=Computers,DC=tragiccode,DC=local'
#     }}

#     it { should contain_class('profile::windows::activedirectory::joindomain') }

#     it { should contain_dsc_xcomputer('Join tragiccode.local domain') }

#     it { should contain_reboot('computer_join_domain_reboot') }

#   end

# end
