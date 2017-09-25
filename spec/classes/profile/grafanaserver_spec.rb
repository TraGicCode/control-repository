# require 'spec_helper'

# describe 'profile::linux::grafanaserver' do
#   context 'with default values for all parameters' do
#     let(:facts) {{
#       :osfamily        => 'Debian',
#       :operatingsystem => 'Ubuntu',
#       :lsbdistrelease  => '16.04',
#       :lsbdistcodename => 'xenial',
#       :kernel          => 'Linux',
#     }}
#     # Needed in order to get that 100% code coverage
#     it { should contain_class('profile::linux::grafanaserver') }

#     it { should contain_class('graphite') }
#     it { should contain_class('grafana') }

#   end
# end
