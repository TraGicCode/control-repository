# Class: profile::windows::sqlserver
#
#
class profile::windows::sqlserver {
  # Get you up to the point where your database is ready to accept schema and data.  it gets you so that point
  # Setup SA
  # Setup Svc account
  # Change where logs are stored

  # Apparently this can be done.  I guess to protect the iso?
  #The ISO Must have execute rights on it so make sure our service has rights to mount it
  # acl { 'c:/staging/profile/SQLServer2014-x64-ENU.iso':
  #   permissions  => [
  #     { identity => 'Everyone', rights       => [ 'full' ] },
  #     { identity => 'Administrators', rights => [ 'full' ] },
  #     { identity => 'vagrant', rights        => [ 'full' ] },
  #   ],
  #   require => Staging::File['SQLServer2014-x64-ENU.iso'],
  #   before  => Mount_iso['c:/staging/profile/SQLServer2014-x64-ENU.iso'],
  # }
  dsc_mountimage { 'SQL Server ISO':
    dsc_ensure      => 'Present',
    dsc_imagepath   => 'C:\\en_sql_server_2016_developer_with_service_pack_1_x64_dvd_9548071.iso',
    dsc_driveletter => 'D',
  }

  dsc_waitforvolume { 'Wait for mounted SQL Server ISO':
    dsc_driveletter => 'D',
    require         => Dsc_mountimage['SQL Server ISO'],
  }

  dsc_sqlsetup { 'Install SQL Server':
    ensure                   => 'present',
    dsc_action               => 'Install',
    dsc_instancename         => 'MSSQLSERVER',
    # dsc_sourcepath        => 'E:\\' # supposed to be UNC i think..
    dsc_sourcepath           => 'D:\\',
    #dsc_sourcecredential   => {
    #     'user'     => $domain_administrator_user,
    #     'password' => $domain_administrator_password,
    # },
    dsc_suppressreboot       => false,
    dsc_forcereboot          => true,
    dsc_features             => 'SQLENGINE',
    # dsc_instanceid        => 'MSSQLSERVER',
    # dsc_productkey        => 'xxx-xxx-xxx-xxx'
    # lint:ignore:quoted_booleans
    dsc_updateenabled        => 'true',
    #dsc_updatesource       => 'C:\\'
    dsc_sqmreporting         => 'true',
    dsc_errorreporting       => 'true',
    # lint:endignore
    # dsc_installshareddir  => 'C:\\',
    # dsc_installsharedwowdir => 'C:\\',
    # dsc_InstanceDir => 'C:\\Program Files\\Microsoft SQL Server',
    # dsc_sqlsvcaccount   => {
    #     'user'     => $domain_administrator_user,
    #     'password' => $domain_administrator_password,
    # },
    # dsc_agtsvcaccount   => {
    #     'user'     => $domain_administrator_user,
    #     'password' => $domain_administrator_password,
    # },
    # dsc_sqlcollation => '',
    dsc_sqlsysadminaccounts  => ['vagrant'],
    # dsc_securitymode        => 'SQL', # 'SQL' aka mixed.  Don't specify for windows only
    # dsc_sapwd             => 'XXXX' # only applicable if mixed security mode
    # dsc_installsqldatadir => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
    # dsc_sdluserdbdir      => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
    # dsc_sqluserdblogdir   => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
    # dsc_sqltempdbdir      => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
    # dsc_sqltempdblogdir     => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Data',
    # dsc_sqlbackupdir        => 'C:\\Program Files\\Microsoft SQL Server\\MSSQL13.MSSQLSERVER\\MSSQL\\Backup',
    # dsc_ftsvcaccount   => {
    #     'user'     => 'vagrant',
    #     'password' => 'vagrant',
    # },
    # dsc_rssvcaccount   => {
    #     'user'     => 'vagrant',
    #     'password' => 'vagrant',
    # },
    # dsc_assvcaccount   => {
    #     'user'     => 'vagrant',
    #     'password' => 'vagrant',
    # },
    # dsc_ascollation => 'SQL_Latin1_General_CP1_CI_AS',
    # dsc_assysadminaccounts => ['vagrant'],
    # dsc_asdatadir         => 'C:\\MSOLAP\\Data',
    # dsc_aslogdir          => 'C:\\MSOLAP\\Log',
    # dsc_asbackupdir       => 'C:\\MSOLAP\\Backup',
    # dsc_astempdir         => 'C:\\MSOLAP\\Temp',
    # dsc_asconfdir           =>  'C:\\MSOLAP\\Config',
    # dsc_issvcaccount   => {
    #     'user'     => 'vagrant',
    #     'password' => 'vagrant',
    # },
    # dsc_browsersvcstartuptype => 'Automatic',
    # dsc_failoverclustergroupname => 'SQL Server (MSSQLSERVER)',
    # dsc_failoverclusteripaddress => ['10.0.0.2', '10.0.0.3'],
    # dsc_failoverclusternetworkname => 'blah',
    # dsc_setupprocesstimeout => 7200, # 2 hours
    dsc_psdscrunascredential => {
        'user'     => 'vagrant',
        'password' => 'vagrant',
    },
  }

  service { 'MSSQLSERVER':
    ensure  => 'running',
    enable  => true,
    require => Dsc_sqlsetup['Install SQL Server'],
  }

  package { 'sql-server-management-studio':
    ensure   => '14.0.17119.0',
    provider => 'chocolatey',
  }

}
