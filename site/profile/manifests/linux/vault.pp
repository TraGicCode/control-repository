# Class: profile::linux::vault
#
#
class profile::linux::vault {
  package { 'unzip':
    ensure => installed,
  }

  class { 'vault':
    listener => {
      tcp => {
        address     => '10.20.1.13:8200',
        tls_disable => 1,
      }
    }
  }
}