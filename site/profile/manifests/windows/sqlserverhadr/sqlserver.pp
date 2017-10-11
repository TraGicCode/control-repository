# Class: profile::windows::sqlserverhadr::sqlserver
# Step By Step on how to do this in azure = https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-availability-group-tutorial
# https://github.com/mrptsai/_old/blob/0426d32231ae472078cd8d1a5b7ad329cf42c022/dsc-scripts/sqlao-cluster/config-sqlao-cluster.ps1
#
class profile::windows::sqlserverhadr::sqlserver(
  String $domain_administrator_user,
  String $domain_administrator_password,
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $fail_over_cluster_static_ip,
) {

  redact('domain_administrator_password')

  dsc_windowsfeature { 'Failover-Clustering':
    dsc_ensure => 'present',
    dsc_name   => 'Failover-Clustering',
  }

  dsc_windowsfeature { 'RSAT-Clustering-Mgmt':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-Clustering-Mgmt',
  }

  dsc_windowsfeature { 'RSAT-Clustering-PowerShell':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-Clustering-PowerShell',
  }


  dsc_xroute { 'Default-Gateway':
    dsc_ensure            => 'present',
    dsc_interfacealias    => 'Ethernet 2',
    dsc_addressfamily     => 'IPv4',
    dsc_destinationprefix => '0.0.0.0/0',
    dsc_nexthop           => '10.20.1.9',
    dsc_routemetric       => 256,
  }

  # dsc_xcluster { 'SQLCluster':
  #   ensure                            => 'present',
  #   dsc_name                          => 'SQLCluster',
  #   dsc_staticipaddress               => $fail_over_cluster_static_ip,
  #   dsc_domainadministratorcredential => {
  #       'user'     => $domain_administrator_user,
  #       'password' => Sensitive($domain_administrator_password),
  #     },
  # }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-operational-index':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Operational',
    setting => 'index',
    value   => 'wineventlog',
  }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-operational-sourcetype':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Operational',
    setting => 'sourcetype',
    value   => 'WinEventLog:System',
  }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-operational-disabled':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Operational',
    setting => 'disabled',
    value   => 0,
  }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-diagnostic-index':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Diagnostic',
    setting => 'index',
    value   => 'wineventlog',
  }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-diagnostic-sourcetype':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Diagnostic',
    setting => 'sourcetype',
    value   => 'WinEventLog:System',
  }

  splunkforwarder_input { 'windows-eventlog-failoverclustering-diagnostic-disabled':
    section => 'WinEventLog://Microsoft-Windows-FailoverClustering/Diagnostic',
    setting => 'disabled',
    value   => 0,
  }
}
