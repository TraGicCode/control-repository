# require 'spec_helper_acceptance'

# describe 'profile::windows::ravendb' do
#   context 'when installing with provided mandatory parameters' do
#     let(:install_manifest) do
#       <<-MANIFEST
#           include role::ravendb
#         MANIFEST
#     end

#     it 'runs without errors' do
#       apply_manifest(install_manifest, catch_failures: true)
#     end

#     it 'is idempotent' do
#       apply_manifest(install_manifest, catch_changes: true)
#     end

#     describe package('RavenDB') do
#       it { is_expected.to be_installed }
#     end

#     describe service('RavenDB') do
#       it { is_expected.to be_running }
#       it { is_expected.to be_enabled }
#     end

#     describe port(8080) do
#       it { is_expected.to be_listening }
#     end
#   end
# end
