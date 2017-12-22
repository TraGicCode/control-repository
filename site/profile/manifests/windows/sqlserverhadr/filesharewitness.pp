# Class: profile::windows::sqlserverhadr::sqlserver
#
# NOTE: The FileShare must live on a node that is not in the cluster ( in my case i selected my dc )
class profile::windows::sqlserverhadr::filesharewitness(
  String $domain_administrator_user,
  String $domain_administrator_password,
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $fail_over_cluster_static_ip,
) {

  redact('domain_administrator_password')

  # New-SmbShare -Name "FileShareWitness" -Path 'C:\FileShareWitness' -ChangeAccess @("tragiccode\supercluster$", "tragiccode\ad_principal_manager")
  dsc_xsmbshare { 'FileShareForWitness':
    dsc_ensure      => 'present' ,
    dsc_name        => 'FileShareForWitness',
    dsc_path        => 'C:\\WSFC-FileShare-Witness',
    # dsc_readaccess => "User1"
    # dsc_noaccess = @("User3", "User4")
    dsc_description => 'Used for fail over clustering with sql server',
  }
}
