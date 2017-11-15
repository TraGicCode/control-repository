require 'spec_helper'

describe 'role::puppetserver' do
  context 'should compile into a catalogue without dependency cycles' do
    # TODO: Open Issue on puppet-rspec.  This looks like it has supposedly been resolved.
    #       For now using this hack
    before :each do
      Puppet[:autosign] = false
      Puppet::Util::Platform.stubs(:windows?).returns false
    end

    # Stub this out.  This is embedded in the catalog automatically from the private puppet enterprise modules
    let(:pre_condition) do
      <<-ANCHORCLASS
     service { 'pe-console-services': }
     ANCHORCLASS
    end

    let(:facts) do
      {
        architecture:           'amd64',
        osfamily:               'Debian',
        kernel:                 'Linux',
        # lsbdistcodename:        'xenial',
        # operatingsystem:        'windows',
        # operatingsystemrelease: '2016',
        # # Stubbing Staging module specific JUNK!
        # staging_windir:         'C:\\ProgramData\\staging',
        # path:                   'C:\\ProgramData\\staging',
        # staged_package:         nil,
        os: { family: 'Debian' },
        # networking: { 'primary' => 'Ethernet' },
      }
    end

    it { is_expected.to compile }
  end
end
