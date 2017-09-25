# Class: profile::windows::defender
#
#
class profile::windows::defender {
  registry_value { 'Turnoff defender':
    ensure => 'present',
    name   => 'HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows Defender\\DisableAntiSpyware',
    type   => dword,
    data   => 1,
  }

}