# Class: role::splunkserver
#
#
class role::splunkserver {
    include profile::base
    include profile::splunk::server

    Class['profile::base']
    -> Class['profile::splunk::server']
}
