class profile::puppet::agent {

  # https://github.com/LMacchi/puppet_agent_settings allows us to get agent puppet.conf settings
  # Add it later
  $puppet_conf = $facts['kernel'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  ini_setting { 'use_cached_catalog':
    ensure  => present,
    path    => $puppet_conf,
    # path    => $facts['puppet_agent_settings']['config'],
    section => 'agent',
    setting => 'use_cached_catalog',
    # lint:ignore:quoted_booleans
    value   => 'true',
    # lint:endignore
  }

  notify { 'hello': }
}
