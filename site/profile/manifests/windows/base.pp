# Class: profile::windows::base
#
#
class profile::windows::base {
  # include profile::firewall
  # include profile::defender

  # Lock users startup folder by changing permissions to prevent them from changing this
  # this prevents hackers/maliciuous software from executing code on startup

  # Lock the host file to prevent malicious software from redirecting the user to a fake website
  # Maybe permissions is fine for this?

  # Stop unnessary services we don't use to reduce attack surface
  # Stop rdp
  # stop smb
  # Stop network places discovery

  # start necessary services
  # start antivirus if installed

  class { 'chocolatey':
    chocolatey_version => '0.10.6.1',
    log_output         => true,
  }

  dsc_xtimezone { 'Server Timezone':
    ensure               => 'present',
    dsc_issingleinstance => 'yes',
    dsc_timezone         => 'UTC',
  }

}