class profile::puppet::agent {

  $puppet_conf = $facts['kernel'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
    default   => '/etc/puppetlabs/puppet/puppet.conf',
  }

  ini_setting { 'use_cached_catalog':
    ensure  => present,
    path    => $puppet_conf,
    section => 'agent',
    setting => 'use_cached_catalog',
    # lint:ignore:quoted_booleans
    value   => 'true',
    # lint:endignore
  }

  notify { 'hello': }
}
