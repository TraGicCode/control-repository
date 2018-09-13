# Class: role::servicecontrol
#
#
class role::servicecontrol {
    include profile::base
    include profile::windows::particular::servicecontrol
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::particular::servicecontrol']
    -> Class['profile::windows::splunk::universalforwarder']
}
