# Class: profile::linux::continuousintegration::ruby
#
#
class profile::linux::continuousintegration::ruby {

  # Dependencies need to build native gems like nokogiri
  package { 'zlib1g-dev':
    ensure => 'present',
  }

  include ruby
  include ruby::dev
}
