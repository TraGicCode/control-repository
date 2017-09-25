# Class: role::servicecontrol
#
#
class role::servicecontrol {
    include profile::base
    include profile::windows::nservicebus::servicecontrol
    include profile::windows::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::windows::nservicebus::servicecontrol']
    -> Class['profile::windows::splunk::universalforwarder']
}