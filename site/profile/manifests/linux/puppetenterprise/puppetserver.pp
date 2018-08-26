class profile::linux::puppetenterprise::puppetserver(
  String[1] $file_source_pe_license  = 'puppet:///modules/profile/puppetenterprise/puppetserver/license.key',
  String $file_source_auto_sign_conf = 'puppet:///modules/profile/puppetenterprise/puppetserver/autosign.conf',
) {

  file { '/etc/puppetlabs/pe-license.key':
    ensure    => present,
    source    => $file_source_pe_license,
    show_diff => false,
    notify    => Service['pe-console-services'],
  }

  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure => present,
    source => $file_source_auto_sign_conf,
    notify => Service['pe-console-services'],
  }




  node_group { 'All Environments':
    ensure               => present,
    description          => 'Environment group parent and default',
    environment          => 'production',
    override_environment => true,
    parent               => 'All Nodes',
    rule                 => ['and', ['~', 'name', '.*']],
  }


  @@dsc_xdnsrecord { 'puppet':
    dsc_ensure => 'present',
    dsc_name   => 'puppet',
    dsc_target => "${facts['hostname']}.tragiccode.local",
    dsc_type   => 'CName',
    dsc_zone   => 'tragiccode.local',
  }
}
