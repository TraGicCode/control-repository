# Class: role::grafanaserver
#
#
class role::grafanaserver {
    include profile::base
    include profile::linux::grafanaserver
    include profile::linux::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::linux::grafanaserver']
    -> Class['profile::linux::splunk::universalforwarder']
}
