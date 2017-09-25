# Class: role::sqlserver
#
#
class role::sqlserver {
    include profile::base
    include profile::windows::sqlserver
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::sqlserver']
    -> Class['profile::windows::splunk::universalforwarder']
}
