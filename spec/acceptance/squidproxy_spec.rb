require 'spec_helper_acceptance'

describe 'profile::linux::squidproxy' do
  context 'when installing with provided mandatory parameters' do
    let(:install_manifest) do
      <<-MANIFEST
          include role::squidproxy
        MANIFEST
    end

    it 'runs without errors' do
      apply_manifest(install_manifest, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(install_manifest, catch_changes: true)
    end

    describe package('squid') do
      it { is_expected.to be_installed }
    end

    describe service('squid') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(3128) do
      it { is_expected.to be_listening }
    end

    describe file('/etc/squid/squid.conf') do
      its(:content) { is_expected.to match %r{#{Regexp.escape('acl localnet src 10.43.192.0/18')}} }
      its(:content) { is_expected.to match %r{#{Regexp.escape('http_access allow localnet')}} }
      its(:content) { is_expected.to match %r{#{Regexp.escape('acl gcp_metadata dst 169.254.169.254')}} }
      its(:content) { is_expected.to match %r{#{Regexp.escape('http_access deny gcp_metadata')}} }
      its(:content) { is_expected.to match %r{#{Regexp.escape('http_access deny all')}} }
      its(:content) { is_expected.to match %r{cache deny all} }
    end
  end
end
