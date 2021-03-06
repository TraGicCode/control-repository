class profile::linux::puppetenterprise::puppetserver(
  String[1] $file_source_pe_license  = 'puppet:///modules/profile/puppetenterprise/puppetserver/license.key',
  String $file_source_auto_sign_conf = 'puppet:///modules/profile/puppetenterprise/puppetserver/autosign.conf',
) {
  # Example of validation to prevent
  # assigning profile to a node with an O/S which is not supported
  # for the profile
  # if $::facts['kernel'] != 'Linux' {
  #   fail('Unsupported OS!')
  # }

  file { '/etc/puppetlabs/license.key':
    ensure    => present,
    source    => $file_source_pe_license,
    show_diff => false,
    notify    => Service['pe-console-services'],
  }

  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure => present,
    notify => Service['pe-console-services'],
  }
  # environment - deploy code with code manager
  # orchestrator - start/view/stop orchestrator jobs
  # puppet_agent - ability to run puppet via orchestrator
  # nodes - ability to query puppetdb
  rbac_role { 'jenkins_puppet_deployer_role':
    ensure      => present,
    description => 'Role used for deploying the control repo code in our jenkins pipeline.',
    permissions =>  [
    {
      'object_type' => 'environment',
      'action'      => 'deploy_code',
      'instance'    => '*',
    },
    {
      'object_type' => 'orchestrator',
      'action'      => 'view',
      'instance'    => '*',
    },
    {
      'object_type' => 'puppet_agent',
      'action'      => 'run',
      'instance'    => '*',
    },
    {
      'object_type' => 'nodes',
      'action'      => 'view_data',
      'instance'    => '*'
    },
    # This is only needed for creating the temp environment in jenkins
    {
      'object_type' => 'node_groups',
      'action'      => 'modify_children',
      'instance'    => '*'
    },
    {
      'object_type' => 'node_groups',
      'action'      => 'view',
      'instance'    => '*'
    },
    {
      'object_type' => 'node_groups',
      'action'      => 'set_environment',
      'instance'    => '*'
    }],
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
