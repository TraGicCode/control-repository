node_group { 'PE Master - Customized':
  ensure               => 'present',
  rule                 => ['and', ['~', ['fact', 'fqdn'], $facts['fqdn']]],
  classes              => {
    'puppet_enterprise::profile::master' => {
      # r10k/code manager
      'r10k_remote'                              => 'https://github.com/TraGicCode/control-repository.git',
      'code_manager_auto_configure'              => true,
      # graphite support             
      'metrics_graphite_enabled'                 => true,
      'metrics_server_id'                        => $facts['hostname'],
      'metrics_graphite_host'                    => 'grafana-001.local',
      'metrics_graphite_update_interval_seconds' => 60,
      'metrics_jmx_enabled'                      => true,
      'metrics_graphite_port'                    => 2003,
      'profiler_enabled'                         => true,
    },
    'pe_repo::platform::windows_x86_64'  => {

    },
  },
  environment          => 'production',
  override_environment => false,
  parent               => 'PE Master',
  provider             => 'https',
}

node_group { 'PE Agent - Customized':
  ensure               => 'present',
  rule                 => ['and', ['~', ['fact', 'aio_agent_version'], '.+']],
  classes              => {
    'puppet_enterprise::profile::agent' => {
      'package_inventory_enabled' => true,
    },
  },
  environment          => 'production',
  override_environment => false,
  parent               => 'PE Agent',
  provider             => 'https',
}

node_group { 'All Environments':
  ensure               => present,
  description          => 'Environment group parent and default',
  environment          => 'production',
  override_environment => true, # This is super confusing but this just indicates if this is an environment group or classification group.
  parent               => 'All Nodes',
  rule                 => ['and', ['~', 'name', '.*']],
}

node_group { 'Agent-specified environment':
  ensure               => present,
  description          => 'This environment group exists for unusual testing and development only. Expect it to be empty',
  environment          => 'agent-specified',
  override_environment => true,
  parent               => 'All Environments',
  rule                 => [ ],
}

['production', 'staging', 'development'].each |$env| {
  $title_env = capitalize($env)

  node_group { "${title_env} environment":
    ensure               => present,
    environment          => $env,
    override_environment => true,
    parent               => 'All Environments',
    rule                 => ['and', ['=', ['trusted', 'extensions', 'pp_environment'], $env]],
  }

  node_group { "${title_env} one-time run exception":
    ensure               => present,
    description          => "Allow ${env} nodes to request a different puppet environment for a one-time run",
    environment          => 'agent-specified',
    override_environment => true,
    parent               => "${title_env} environment",
    rule                 => ['and', ['~', ['fact', 'agent_specified_environment'], '.+']],
  }
}

