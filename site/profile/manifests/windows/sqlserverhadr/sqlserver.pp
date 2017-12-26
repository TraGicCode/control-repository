# Class: profile::windows::sqlserverhadr::sqlserver
# Step By Step on how to do this in azure = https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-availability-group-tutorial
# https://www.mssqltips.com/sqlservertip/4928/configure-network-binding-order-for-a-windows-server-2016-failover-cluster/
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

# new-netroute -DestinationPrefix '0.0.0.0/0' -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4 -NextHop '10.20.1.9' -RouteMetric 256
# This is so i can create the cluster with its ip on the same subnet as Ethernet 2 in my vagrant box
# Set-DnsClientServerAddress -InterfaceAlias 'Ethernet 2' -ServerAddresses ("10.20.1.7")
# I need to disable DHCP on port forwarding NIC or it will not be ignored and when the cluster is created the NIC will be added as a network!
# This is the magic sauce here for getting our cluster to ignore the 10.0.2.15 network that vagrant creates/uses for port forwarding
# Get-NetAdapter -Name 'Ethernet' | Set-NetIPInterface -DHCP Disabled
#
# Create cluster powershell here
# 
# New-Cluster -Name SQLCluster -Node sql-001 -StaticAddress 10.20.1.22 -NoStorage
#
# Repeat on second node but run this afterward
# Add-ClusterNode -Name sql-002 -Cluster supercluster -NoStorage -Verbose
# if $facts['virtual'] == 'virtualbox' {
# Remove-ClusterResource -Name "Cluster IP Address 10.0.2.0" -Force
#   dsc_xroute { 'Default-Gateway':
#     dsc_ensure            => 'present',
#     dsc_interfacealias    => 'Ethernet 2',
#     dsc_addressfamily     => 'IPv4',
#     dsc_destinationprefix => '0.0.0.0/0',
#     dsc_nexthop           => $facts['networking']['interfaces']['Ethernet 2']['ip'],
#     dsc_routemetric       => 256,
#   }

#   dsc_xdhcpclient { 'DHCP-Client-Ethernet-IPv4':
#     dsc_state          => 'Disabled',
#     dsc_interfacealias => 'Ethernet',
#     dsc_addressfamily  => 'IPv4',
#   }
# }

 dsc_xcluster { 'SQLCluster':
   ensure                            => 'present',
   dsc_name                          => 'SQLCluster',
   dsc_staticipaddress               => $fail_over_cluster_static_ip,
   dsc_domainadministratorcredential => {
       'user'     => $domain_administrator_user,
       'password' => $domain_administrator_password,
     },
 }

 if $facts['virtual'] == 'virtualbox' {
  exec { 'remove-virtualbox-nat-ip-from-cluster':
    command     => 'Remove-ClusterResource -Name "Cluster IP Address 10.0.2.0" -Force',
    logoutput   => true,
    refreshonly => true,
    provider    => powershell,
  }
 }

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
