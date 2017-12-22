# Class: profile::windows::sqlserverhadr::sqlserver
#
# NOTE: The FileShare must live on a node that is not in the cluster ( in my case i selected my dc )
class profile::windows::sqlserverhadr::filesharewitness(
) {

  file { 'C:\FileShareWitness':
    ensure => 'directory',
  }

  # New-SmbShare -Name "FileShareWitness" -Path 'C:\FileShareWitness' -ChangeAccess @("tragiccode\supercluster$", "tragiccode\ad_principal_manager")
  dsc_xsmbshare { 'FileShareWitness':
    dsc_ensure       => 'present' ,
    dsc_name         => 'FileShareWitness',
    dsc_path         => 'C:\\WSFC-FileShare-Witness',
    dsc_readaccess   => [ 'tragiccode\\ad_principal_manager' ],
    dsc_changeaccess => [ 'tragiccode\\supercluster$' ],
    dsc_description  => 'Used to break the tie in windows server failover clustering for SQL Server Always-On',
    require          => File['C:\\FileShareWitness'],
  }
}
