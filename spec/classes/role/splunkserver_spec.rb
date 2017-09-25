require 'spec_helper'

describe 'role::splunkserver' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily: 'Debian',
        kernel: 'Linux',
        architecture: 'amd64',
        :os                     => { family: 'Debian', },
      }
    end

    it { is_expected.to compile }
  end
end
