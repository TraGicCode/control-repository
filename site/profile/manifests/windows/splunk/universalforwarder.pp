# Class: profile::windows::splunk::universalforwarder
#
class profile::windows::splunk::universalforwarder(
  String $splunk_dot_secret_file_content,
) {

  redact('splunk_dot_secret_file_content')

  class { 'splunk::params':
    server   => 'splunkserver-001.local',
    version  => '7.0.0',
    build    => 'c8a78efdd40f',
  }

  class { 'splunk::forwarder':
    # indicates the user + group to be used for granting permissions to splunk configuration files on disk
    # not sure why this blows up in vagrant when i specify a user...
    # splunk_user  => 'vagrant', # indicates the user + group to be used for granting permissions to splunk configuration files on disk
    install_options => [
      'AGREETOLICENSE=Yes',
      'LAUNCHSPLUNK=0',
      'SERVICESTARTTYPE=auto',
      'WINEVENTLOG_APP_ENABLE=0',
      'WINEVENTLOG_SEC_ENABLE=0',
      'WINEVENTLOG_SYS_ENABLE=0',
      'WINEVENTLOG_FWD_ENABLE=0',
      'WINEVENTLOG_SET_ENABLE=1',
      'ENABLEADMON=0',
      { 'INSTALLDIR' => 'C:\\Program Files\\SplunkUniversalForwarder' },
    ],
  }

  splunkforwarder_server { 'ssl-config-sslPassword':
    section => 'sslConfig',
    setting => 'sslPassword',
    value   => '$1$Bj3FSJRCLtSH',
    require => Class['splunk::forwarder'],
    notify  => Service['SplunkForwarder'],
  }

  class { 'splunk::password':
    password_config_file => 'C:\\Program Files\\SplunkUniversalForwarder\\etc\\passwd',
    password_content     => ':admin:$6$ppd1j5iNShf7TXxF$iRbBaeWLYbmPQwJOZ4McPJHSeTwXV3o52Oay.BG5Yaj5MbHLxHYmCjssHmNHhvSbAu7dk9PYdZD50h3p1Eadz0::Administrator:admin:changeme@example.com::',
    secret_file          => 'C:\\Program Files\\SplunkUniversalForwarder\\etc\\auth\\splunk.secret',
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

  splunkforwarder_input { 'windows-eventlog-application-index':
    section => 'WinEventLog://Application',
    setting => 'index',
    value   => 'g_wineventlog',
  }

  splunkforwarder_input { 'windows-eventlog-application-sourcetype':
    section => 'WinEventLog://Application',
    setting => 'sourcetype',
    value   => 'WinEventLog:Application',
  }

  splunkforwarder_input { 'windows-eventlog-application-disabled':
    section => 'WinEventLog://Application',
    setting => 'disabled',
    value   => 0,
  }

  splunkforwarder_input { 'windows-eventlog-security-index':
    section => 'WinEventLog://Security',
    setting => 'index',
    value   => 'g_wineventlog',
  }

  splunkforwarder_input { 'windows-eventlog-security-sourcetype':
    section => 'WinEventLog://Security',
    setting => 'sourcetype',
    value   => 'WinEventLog:Security',
  }

  splunkforwarder_input { 'windows-eventlog-security-disabled':
    section => 'WinEventLog://Security',
    setting => 'disabled',
    value   => 0,
  }

  splunkforwarder_input { 'windows-eventlog-system-index':
    section => 'WinEventLog://System',
    setting => 'index',
    value   => 'g_wineventlog',
  }

  splunkforwarder_input { 'windows-eventlog-system-sourcetype':
    section => 'WinEventLog://System',
    setting => 'sourcetype',
    value   => 'WinEventLog:System',
  }

  splunkforwarder_input { 'windows-eventlog-system-disabled':
    section => 'WinEventLog://System',
    setting => 'disabled',
    value   => 0,
  }
}
