class profile::windows::hardening::hardening(

) {
  # Causes computers to be autodiscovered and show up in "My network places"
  service { 'Browser':
    ensure => 'stopped',
    enable => false,
  }

  # Disable SMB 
  # aka File, print, and named pipe sharing over the network
  # NOTE: this has a Dependency on 'Browser' service so i need to stop this as well
  service { 'LanmanServer':
    ensure  => 'stopped',
    enable  => false,
    require => Service['Browser'],
  }
}