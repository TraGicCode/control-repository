# Class: profile::linux::git
#
#
class profile::linux::git {
  package { 'git':
    ensure => installed,
  }
}