# == Class: profile::splunk
#
class profile::splunk::server {

  # TODO:
  #      Currently i don't have an automated way to enable remote forwarding in splunk on the server
  #      settings => forwarding and receiving => Receive Data => Configure Receiving => enable
  class { 'splunk::params':
      version  => '7.0.0',
      build    => 'c8a78efdd40f',
  }

  include splunk

  # which clients to include.  Include them all!
  splunk_serverclass { 'serverclass-global-whitelist':
    section => 'global',
    setting => 'whitelist.0',
    value   => '*',
    require => Class['splunk'],
  }

  # Which server classes we have
  splunk_serverclass { 'serverclass-windows-machines':
    section => 'serverClass:WindowsMachines',
    setting => 'machineTypesFilter',
    value   => 'windows-*',
    require => Class['splunk'],
  }

  splunk_serverclass { 'serverclass-windows-technology-addon':
    section => 'serverClass:WindowsMachines:app:Splunk_TA_windows',
    setting => 'restartIfNeeded',
    value   => true,
    require => Class['splunk'],
  }

  # [serverClass:WindowsMachineTypes:app:WindowsApp]
  # [serverClass:LinuxMachineTypes]
  # machineTypesFilter=linux-i686, linux-x86_64
  splunk_serverclass { 'serverclass-linux-machines':
    section => 'serverClass:LinuxMachines',
    setting => 'machineTypesFilter',
    value   => 'linux-i686, linux-x86_64',
    require => Class['splunk'],
  }

  ######################################
  # Windows App Customization
  ######################################
  # [wineventlog-index]
  # definition = (index=g_wineventlog OR index=main)
  # [perfmon-index]
  # definition = index=main
  # [msad-index]
  # definition = index=main
  ini_setting { 'windows-app-infrastructure-wineventlog-index-macro':
    ensure            => present,
    path              => '/opt/splunk/etc/apps/splunk_app_windows_infrastructure/default/macros.conf',
    section           => 'wineventlog-index',
    key_val_separator => ' = ',
    setting           => 'definition',
    value             => '(index=g_wineventlog OR index=main)',
    require           => Class['splunk'],
  }


  # TODO: Somehow automate installation of Splunk Technology Addon because i need to COPY the extracted folder on the splunk server
  # from : /opt/splunk/etc/apps/Splunk_TA_windows
  # To:   /opt/splunk/etc/deployment-apps/Splunk_TA_windows
  # cp -a /opt/splunk/etc/apps/Splunk_TA_windows/ /opt/splunk/etc/deployment-apps/


  # /opt/splunk/etc/system/local/web.conf
  # [settings]
  # mgmtHostPort=127.0.0.1:8089
  # httpport=8000 # will be https port
  # enableSplunkWebSSL = 1
  # # privKeyPath = /opt/splunk/etc/auth/splunkweb/privkey.pem
  # # caCertPath = /opt/splunk/etc/auth/splunkweb/cert.pem
  ######################################
  # Linux Sys Log
  ######################################
  splunk_indexes { 'linux-syslog-index-homePath':
    section => 'g_syslog',
    setting => 'homePath',
    value   => '$SPLUNK_DB/g_syslog/db',
    require => Class['splunk'],
  }

  splunk_indexes { 'linux-syslog-index-maxTotalDataSizeMB':
    section => 'g_syslog',
    setting => 'maxTotalDataSizeMB',
    value   => '1024',
    require => Class['splunk'],
  }

  splunk_indexes { 'linux-syslog-index-coldPath':
    section => 'g_syslog',
    setting => 'coldPath',
    value   => '$SPLUNK_DB/g_syslog/colddb',
    require => Class['splunk'],
  }

  splunk_indexes { 'linux-syslog-index-thawedPath':
    section => 'g_syslog',
    setting => 'thawedPath',
    value   => '$SPLUNK_DB/g_syslog/thaweddb',
    require => Class['splunk'],
  }

  ######################################
  # Windows Event Log
  ######################################
  splunk_indexes { 'windows-eventlog-index-homePath':
    section => 'g_wineventlog',
    setting => 'homePath',
    value   => '$SPLUNK_DB/g_wineventlog/db',
    require => Class['splunk'],
  }

  splunk_indexes { 'windows-eventlog-index-maxTotalDataSizeMB':
    section => 'g_wineventlog',
    setting => 'maxTotalDataSizeMB',
    value   => '1024',
    require => Class['splunk'],
  }

  splunk_indexes { 'windows-eventlog-index-coldPath':
    section => 'g_wineventlog',
    setting => 'coldPath',
    value   => '$SPLUNK_DB/g_wineventlog/colddb',
    require => Class['splunk'],
  }

  splunk_indexes { 'windows-eventlog-index-thawedPath':
    section => 'g_wineventlog',
    setting => 'thawedPath',
    value   => '$SPLUNK_DB/g_wineventlog/thaweddb',
    require => Class['splunk'],
  }

  ######################################
  # Puppet Server
  ######################################
  ## PuppetServer logs
  # https://docs.puppet.com/pe/latest/install_what_and_where.html#log-files-installed
  splunk_indexes { 'g_puppetserver-index-homePath':
    section => 'g_puppetserver',
    setting => 'homePath',
    value   => '$SPLUNK_DB/g_puppetserver/db',
    require => Class['splunk'],
  }

  splunk_indexes { 'puppetserver-index-maxTotalDataSizeMB':
    section => 'g_puppetserver',
    setting => 'maxTotalDataSizeMB',
    value   => '1024',
    require => Class['splunk'],
  }
  splunk_indexes { 'puppetserver-index-colddb':
    section => 'g_puppetserver',
    setting => 'coldPath',
    value   => '$SPLUNK_DB/puppetserver/colddb',
    require => Class['splunk'],
  }

  splunk_indexes { 'puppetserver-index-thawedpath':
    section => 'g_puppetserver',
    setting => 'thawedPath',
    value   => '$SPLUNK_DB/puppetserver/thaweddb',
    require => Class['splunk'],
  }

  splunk_props { 'puppetserver-logs-message':
    section => 'g_puppetserver',
    setting => 'EXTRACT-message',
    value   => '^(?:[^ \n]* ){6}(?P<message>.+)',
    require => Class['splunk'],
  }

  splunk_props { 'puppetserver-logs-level':
    section => 'g_puppetserver',
    setting => 'EXTRACT-level',
    value   => '^[^,\n]*,\d+\s+(?P<level>\w+)',
    require => Class['splunk'],
  }

  # splunk_indexes { 'autobahn-log4net-index-homepath':
  #   section => 'ab_log4',
  #   setting => 'homePath',
  #   value   => '$SPLUNK_DB/ab_log4/db',
  #   require => Class['splunk'],
  # }
  # splunk_indexes { 'autobahn-log4net-index-maxsize':
  #   section => 'ab_log4',
  #   setting => 'maxTotalDataSizeMB',
  #   value   => 10240,
  #   require => Class['splunk'],
  # }

  # splunk_indexes { 'autobahn-log4net-index-colddb':
  #   section => 'ab_log4',
  #   setting => 'coldPath',
  #   value   => '$SPLUNK_DB/ab_log4/colddb',
  #   require => Class['splunk'],
  # }

  # splunk_indexes { 'autobahn-log4net-index-thawedpath':
  #   section => 'ab_log4',
  #   setting => 'thawedPath',
  #   value   => '$SPLUNK_DB/ab_log4/thaweddb',
  #   require => Class['splunk'],
  # }
  # [ab_log4]
  # coldPath = $SPLUNK_DB/ab_log4/colddb
  # enableDataIntegrityControl = 0
  # enableTsidxReduction = 1
  # homePath = $SPLUNK_DB/ab_log4/db
  # maxTotalDataSizeMB = 10240
  # thawedPath = $SPLUNK_DB/ab_log4/thaweddb
  # timePeriodInSecBeforeTsidxReduction = 1209600
  # tsidxReductionCheckPeriodInSec =
  # [Autobahn:Log4Net]
  # DATETIME_CONFIG =
  # NO_BINARY_CHECK = true
  # category = Application
  # description = Autobahn Log4Net Conventions
  # pulldown_type = 1
  # disabled = false
  # EXTRACT-level = ^[^,\n]*,\d+\s+(?P<level>\w+)
  # EXTRACT-logger = ^(?:[^ \n]* ){3}(?P<logger>[^ ]+)
  # EXTRACT-message = ^(?:[^ \n]* ){5}(?P<message>.+)


  # splunk_indexes { 'puppetserver-index-homepath':
  #   section => 'puppetserver',
  #   setting => 'homePath',
  #   value   => '$SPLUNK_DB/puppetserver/db',
  #   require => Class['splunk'],
  # }
  # splunk_indexes { 'puppetserver-index-maxsize':
  #   section => 'puppetserver',
  #   setting => 'maxTotalDataSizeMB',
  #   value   => 10240,
  #   require => Class['splunk'],
  # }

  # ## Autobahn log4net logs
  # splunk_props { 'autobahn-log4net-extraction':
  #   section => 'Log4Net:Autobahn',
  #   setting => 'EXTRACT-level',
  #   value   => '^[^,\n]*,\d+\s+(?P<level>\w+)',
  #   require => Class['splunk'],
  # }

  # splunk_props { 'autobahn-log4net-logger':
  #   section => 'Log4Net:Autobahn',
  #   setting => 'EXTRACT-logger',
  #   value   => '^(?:[^ \n]* ){3}(?P<logger>[^ ]+)',
  #   require => Class['splunk'],
  # }

  # splunk_props { 'autobahn-log4net-message':
  #   section => 'Log4Net:Autobahn',
  #   setting => 'EXTRACT-message',
  #   value   => '^(?:[^ \n]* ){5}(?P<message>.+)',
  #   require => Class['splunk'],
  # }

  # splunk_uiprefs { 'default-search-earliest-time':
  #   section => 'search',
  #   setting => 'dispatch.earliest_time',
  #   value   => '@d',
  #   require => Class['splunk'],
  # }

  # splunk_uiprefs { 'default-search-latest-time':
  #   section => 'search',
  #   setting => 'dispatch.latest_time',
  #   value   => 'now',
  #   require => Class['splunk'],
  # }

}
