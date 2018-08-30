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

  rbac_role { 'jenkins_puppet_deployer_role':
    ensure      => present,
    description => 'Role used for deploying the control repo code in our jenkins pipeline.',
    permissions =>  [
      { 'action'      => 'deploy_code',
        'instance'    => '*',
        'object_type' => 'environment',
      },
    ],
  }

  rbac_user { 'jenkins_puppet_deployer':
    ensure       => present,
    display_name => 'jenkins_puppet_deployer',
    email        => 'jenkins_puppet_deployer@tragiccode.local',
    password     => 'test123!',
    roles        => ['jenkins_puppet_deployer_role'],
    require      => Rbac_role['jenkins_puppet_deployer_role'],
  }

  @@dsc_xdnsrecord { 'puppet':
    dsc_ensure => 'present',
    dsc_name   => 'puppet',
    dsc_target => "${facts['hostname']}.tragiccode.local",
    dsc_type   => 'CName',
    dsc_zone   => 'tragiccode.local',
  }
}
