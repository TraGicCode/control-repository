class role::cd4pe {
  include profile::base
  include profile::linux::puppetlabs::cd4pe

  Class['profile::base']
  -> Class['profile::linux::puppetlabs::cd4pe']
}
