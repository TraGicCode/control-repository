# Class: role::jenkinsmaster
#
#
class role::jenkinsmaster {
    # resources
    include profile::base
    include profile::linux::git
    include profile::linux::continuousintegration::ruby
    include profile::linux::jenkinsmaster
    include profile::linux::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::linux::git']
    -> Class['profile::linux::continuousintegration::ruby']
    -> Class['profile::linux::jenkinsmaster']
    -> Class['profile::linux::splunk::universalforwarder']
}
