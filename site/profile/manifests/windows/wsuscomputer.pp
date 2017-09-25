# Class: profle::windows::wsuscomputer
#
#
class profile::windows::wsuscomputer {
    class { 'wsus_client':
        server_url           => 'http://10.20.1.14:8530',
        enable_status_server => true,
        target_group         => 'services',
    }
}