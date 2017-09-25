require 'spec_helper'

describe 'role::squidproxy' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '16.04',
        kernel: 'Linux',
        architecture: 'amd64',
        :os                     => { family: 'Debian', },
      }
    end

    it { is_expected.to compile }
  end
end
