# Class: role::test
#
#
class role::test {
  include profile::base
  include profile::linux::splunk::universalforwarder

  Class['profile::base']
  -> Class['profile::linux::splunk::universalforwarder']
}