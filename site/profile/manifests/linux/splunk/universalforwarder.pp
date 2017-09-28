# Class: profile::linux::splunk::universalforwarder
#
#
# Notes for distributing new splunk universal forwarder admin credentials to all nodes
# 1.) Bring up a new server ( or existing server )
# 2.) Install/Ensure the splunk universal forwarder is installed
# 3.) Change the admin credentials to something secure
#     > sudo opt/splunkforwarder/bin/splunk edit user admin -pasword <securepasswordhere> -auth admin:changeme
# 4.) Restart splunk to let it encrypt and begin utilizing these new credentials
#     > sudo opt/splunkforwarder/bin/splunk restart
# 5.) Perform an operation on the forwarder to make sure the new credentials are indeed set to what you expect
#     > sudo opt/splunkforwarder/bin/splunk list forward-server
# 6.) Now lets begin extracting the content of specific files to enable puppet to distribute these credentials securely. Go to the following files and extract the specific content of each
#
#     /opt/splunkforwarder/etc/system/local/server.conf
#       [sslConfig]
#       sslPassword = $1$XXXXXXXXX
#
#     /opt/splunkforwarder/etc/passwd
#     :admin:$6$pp5iNShf7TXxF$iRbBaeWLYbmPQwJOZ4McPJHSeTwXV3o52O5Yaj5MbHLxHYmCjssHmNHhvSbAu7dk9D50h3p1Eadz0::Administrator:admin:changeme@example.com::
#
#     /opt/splunkforwarder/etc/auth/splunk.secret
#     3SBurCgoKQUOkSW9FRHztITkK8wXbUut2z9MCD8eiZgKYdqvoibz/pHxKjF5Pftjz4py/BQxKh8TgKPoL43SBurCgYebhpSyr2/qgKP8NhY.drL24OBhg$
class profile::linux::splunk::universalforwarder(
  String $splunk_dot_secret_file_content,
) {

  redact('splunk_dot_secret_file_content')


  class { 'splunk::params':
    server   => 'splunkserver-001.local',
    src_root => 'https://storage.googleapis.com/puppet-provisioning-binaries/splunk',
    version  => '6.6.2',
    build    => '4b804538c686',
  }



  class { 'splunk::forwarder':
    # indicates the user + group to be used for granting permissions to splunk configuration files on disk
    # not sure why this blows up in vagrant when i specify a user...
    # splunk_user  => 'vagrant', # indicates the user + group to be used for granting permissions to splunk configuration files on disk
  }

  splunkforwarder_server { 'ssl-config-sslPassword':
    section => 'sslConfig',
    setting => 'sslPassword',
    value   => '$1$Bj3FSJRCLtSH',
    require => Class['splunk::forwarder'],
    notify  => Service['splunk'],
  }

  class { 'splunk::password':
    password_config_file => '/opt/splunkforwarder/etc/passwd',
    password_content     => ':admin:$6$ppd1j5iNShf7TXxF$iRbBaeWLYbmPQwJOZ4McPJHSeTwXV3o52Oay.BG5Yaj5MbHLxHYmCjssHmNHhvSbAu7dk9PYdZD50h3p1Eadz0::Administrator:admin:changeme@example.com::',
    secret_file          => '/opt/splunkforwarder/etc/auth/splunk.secret',
    secret               => $splunk_dot_secret_file_content,
  }

  ###############################################
  # Configure forwarder to be a deployment client
  ###############################################
  splunkforwarder_deploymentclient { 'deployment-server':
    section => 'target-broker:deploymentServer',
    setting => 'targetUri',
    value   => 'splunkserver-001.local:8089',
  }

  splunkforwarder_input { 'syslog-index':
    section => 'monitor:///var/log/syslog',
    setting => 'index',
    value   => 'g_syslog',
  }

  splunkforwarder_input { 'syslog-sourcetype':
    section => 'monitor:///var/log/syslog',
    setting => 'sourcetype',
    value   => 'syslog',
  }

  splunkforwarder_input { 'syslog-disabled':
    section => 'monitor:///var/log/syslog',
    setting => 'disabled',
    value   => 0,
  }
}
