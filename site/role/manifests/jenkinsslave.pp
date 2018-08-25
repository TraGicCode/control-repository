class role::jenkinsslave {

    include profile::base
    include profile::linux::git
    include profile::linux::jenkins::slave
    include profile::linux::splunk::universalforwarder

    Class['profile::base']
    -> Class['profile::linux::git']
    -> Class['profile::linux::jenkins::slave']
    -> Class['profile::linux::splunk::universalforwarder']
}
