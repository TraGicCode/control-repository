# Class: role::ravendb
#
#
class role::ravendb {
    include profile::base
    include profile::windows::ravendb
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::ravendb']
    -> Class['profile::windows::splunk::universalforwarder']
}
