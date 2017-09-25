# Class: role::chatbot
#
#
class role::chatbot {
  include profile::base
  include profile::linux::lita
  include profile::linux::splunk::universalforwarder

  Class['profile::base']
  -> Class['profile::linux::lita']
  -> Class['include profile::linux::splunk::universalforwarder']
}