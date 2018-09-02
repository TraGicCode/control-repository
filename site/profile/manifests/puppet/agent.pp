class profile::puppet::agent {
  ini_setting { 'use_cached_catalog':
    ensure  => present,
    path    => $::settings::config,
    section => 'agent',
    setting => 'use_cached_catalog',
    # lint:ignore:quoted_booleans
    value   => 'true',
    # lint:endignore

  }
}
