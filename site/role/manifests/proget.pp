# Class: role::proget
#
#
class role::proget {
  include profile::base
  include profile::windows::packagemanagement::proget
  include profile::windows::splunk::universalforwarder

  Class['profile::base']
  -> Class['profile::windows::packagemanagement::proget']
  -> Class['profile::windows::splunk::universalforwarder']
}
