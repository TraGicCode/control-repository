require 'spec_helper'

describe 'role::servicecontrol' do
  context 'should compile into a catalogue without dependency cycles' do
    let(:facts) do
      {
        osfamily:               'windows',
        kernel:                 'windows',
        choco_install_path:     'C:\ProgramData\chocolatey',
        chocolateyversion:      '0.9.9.8',
        architecture:           'x64',
        staged_package:         nil,
      }
    end

    it { is_expected.to compile }
  end
end
