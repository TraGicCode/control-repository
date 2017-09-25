require 'spec_helper'

describe 'role::rabbitmq' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystemmajrelease: '16.04',
        os: { 'name' => 'Ubuntu', 'release' => { 'full' => '16.04' }, 'family' => 'Debian' },
        kernel: 'Linux',
        architecture: 'amd64',
      }
    end

    it { is_expected.to compile }
  end
end
