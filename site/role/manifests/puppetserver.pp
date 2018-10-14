class role::puppetserver {

  #This role would be made of all the profiles that need to be included to make a puppetserver work
  #All roles should include the base profile
  include profile::base
  include profile::linux::puppetenterprise::puppetserver
  include profile::linux::splunk::universalforwarder
  #include profile::linux::azure_hiera_test

  Class['profile::base']
  -> Class['profile::linux::puppetenterprise::puppetserver']
  -> Class['profile::linux::splunk::universalforwarder']
 # -> Class['profile::linux::azure_hiera_test']
}
