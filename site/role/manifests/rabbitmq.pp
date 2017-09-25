# Class: role::rabbitmq
#
#
class role::rabbitmq {
  include profile::base
  include profile::linux::rabbitmq
  include profile::linux::splunk::universalforwarder

  Class['profile::base']
  -> Class['profile::linux::rabbitmq']
  -> Class['profile::linux::splunk::universalforwarder']
}
