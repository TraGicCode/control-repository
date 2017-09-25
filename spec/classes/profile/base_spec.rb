# require 'spec_helper'

# describe 'profile::base' do

#   context 'with default values for all parameters' do
#     it { should contain_class('profile::base') }
#   end

#   context 'with kernel => windows' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :kernel => 'windows',
#     }}

#     it { should contain_class('profile::windows::base')}
#   end

#   context 'with kernel => Linux' do
#     # https://github.com/puppetlabs/pltraining-bootstrap/blob/804c4c27e452d8272d48ef843e29eadd058e3ab8/spec/classes/guacamole_spec.rb
#     let(:facts) {{
#         :kernel => 'Linux',
#     }}

#     it { should contain_class('profile::linux::base')}
#   end
# end
