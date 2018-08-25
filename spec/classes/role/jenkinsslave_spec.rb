require 'spec_helper'

describe 'role::jenkinsslave' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '16.04',
        operatingsystem: 'Ubuntu',
        architecture: 'amd64',
        lsbdistcodename: 'xenial',
        os: { 'name' => 'Ubuntu', 'release' => { 'full' => '16.04' } },
        jenkins_plugins: nil,
        kernel: 'Linux',
      }
    end

    it { is_expected.to compile }
  end
end
