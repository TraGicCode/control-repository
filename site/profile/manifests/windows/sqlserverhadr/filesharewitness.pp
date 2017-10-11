# Class: profile::windows::sqlserverhadr::sqlserver
# Step By Step on how to do this in azure = https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-availability-group-tutorial
# https://github.com/mrptsai/_old/blob/0426d32231ae472078cd8d1a5b7ad329cf42c022/dsc-scripts/sqlao-cluster/config-sqlao-cluster.ps1
#
class profile::windows::sqlserverhadr::filesharewitness(
  String $domain_administrator_user,
  String $domain_administrator_password,
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $fail_over_cluster_static_ip,
) {

  redact('domain_administrator_password')

  dsc_xsmbshare { 'FileShareForWitness':
    dsc_ensure      => 'present' ,
    dsc_name        => 'FileShareForWitness',
    dsc_path        => 'C:\\',
    # dsc_readaccess => "User1"
    # dsc_noaccess = @("User3", "User4")
    dsc_description => 'Used for fail over clustering with sql server',
  }
}
