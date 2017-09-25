# require 'spec_helper'

# describe 'profile::linux::base' do

#   context 'with default values for all parameters' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :networking => { 'ip' => '10.0.2.10', },
#         :hostname   => 'g-x-00-wi-pup001',
#     }}

#     let(:params) {{
#         :domain_name => 'tragiccode.local'
#     }}

#     it { should contain_class('profile::linux::base') }

#   end

#   describe 'exported_resources' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     subject { exported_resources }
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :networking => { 'ip' => '10.0.2.10', },
#         :hostname   => 'g-x-00-wi-pup001',
#     }}

#     let(:params) {{
#         :domain_name => 'tragiccode.local'
#     }}
#     it { should contain_dsc_xdnsrecord('ARecord').with({
#         :dsc_ensure => 'present',
#         :dsc_name   => 'g-x-00-wi-pup001',
#         :dsc_target => '10.0.2.10',
#         :dsc_type   => 'ARecord',
#         :dsc_zone   => 'tragiccode.local',
#     })}
#    end

# end
