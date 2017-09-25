# Class: role::windowsworkstation
#
#
class role::windowsworkstation {
    include profile::base
    include profile::windows::wsuscomputer
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::wsuscomputer']
    -> Class['profile::windows::splunk::universalforwarder']
}