# Class: profile::windows::packagemanagement::proget
#
#
class profile::windows::packagemanagement::proget {
  package { 'proget':
    ensure   => '4.7.13',
    provider => 'chocolatey',
  }
}