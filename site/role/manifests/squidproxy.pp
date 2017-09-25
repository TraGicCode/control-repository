# Class: role::squidproxy
#
#
class role::squidproxy {
    include profile::base
    include profile::linux::squidproxy
    include profile::linux::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::linux::squidproxy']
    -> Class['profile::linux::splunk::universalforwarder']
}
