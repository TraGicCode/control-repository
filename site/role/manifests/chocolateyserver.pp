class role::chocolateyserver {
  include profile::base
  include profile::windows::chocolatey::simple_server

  Class['profile::base']
  -> Class['profile::windows::chocolatey::simple_server']
}
