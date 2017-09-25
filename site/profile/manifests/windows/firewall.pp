# Class: profile::windows::firewall
#
#
class profile::windows::firewall {
  class { 'windows_firewall':
    ensure => 'disabled',
  }
}