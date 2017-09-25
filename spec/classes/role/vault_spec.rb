require 'spec_helper'

describe 'role::vault' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        processorcount: 4,
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        lsbdistcodename: 'xenial',
        architecture: 'amd64',
        kernel: 'Linux',
        networking: { 'ip' => '10.0.2.10' },
        hostname: 'g-x-00-wi-pup001',
        :os                     => { family: 'Debian', },
      }
    end

    it { is_expected.to compile }
  end
end
