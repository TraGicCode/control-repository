# Class: role::sqlserverhadr
#
#
class role::sqlserverhadr {
    include profile::base
    include profile::windows::dnsclient
    include profile::windows::activedirectory::domainmemberserver
    include profile::windows::sqlserverhadr::sqlserver
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::dnsclient']
    -> Class['profile::windows::activedirectory::domainmemberserver']
    -> Class['profile::windows::sqlserverhadr::sqlserver']
    -> Class['profile::windows::splunk::universalforwarder']
}
