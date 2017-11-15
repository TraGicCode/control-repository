require 'spec_helper'

describe 'role::grafanaserver' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        lsbdistrelease: '16.04',
        kernel: 'Linux',
        architecture: 'amd64',
        lsbdistcodename: 'xenial',
        os: { family: 'Debian' },
        # :jenkins_plugins        => nil,
      }
    end

    it { is_expected.to compile }
  end
end
