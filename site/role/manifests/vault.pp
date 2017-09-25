# Class: role::vault
#
#
class role::vault {
  include profile::base
  include profile::linux::vault
  include profile::linux::splunk::universalforwarder

  Class['profile::base']
  -> Class['profile::linux::vault']
  -> Class['profile::linux::splunk::universalforwarder']
}