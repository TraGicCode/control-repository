# Class: profile::windows::windowsupdateserver
#
#
# NOTE: If you create a wsus server and notice cpu peggaed at 80-100% and wsus clients are timing out
#       install the following update which contains the hotfix
#       Windows Server 2016 (KB4039396)
#       https://blogs.technet.microsoft.com/configurationmgr/2017/08/18/high-cpuhigh-memory-in-wsus-following-update-tuesdays/
#       
class profile::windows::windowsupdateserver {

  $products = [
    'Active Directory Rights Management Services Client 2.0',
    'ASP.NET Web Frameworks',
    'Microsoft SQL Server 2012',
    'SQL Server Feature Pack',
    'SQL Server 2012 Product Updates for Setup',
    'Windows Server 2016',
  ]

  $update_classifications = [
    'Critical Updates',
    'Definition Updates',
    'Feature Packs',
    'Security Updates',
    'Service Packs',
    'Tools',
    'Update Rollups',
    'Updates',
    'Upgrades',
  ]

  class { 'wsusserver':
    package_ensure                     => 'present',
    include_management_console         => true,
    wsus_directory                     => 'C:\\WSUS',
    join_improvement_program           => false,
    sync_from_microsoft_update         => true,
    update_languages                   => ['en'],
    products                           => $products,
    update_classifications             => $update_classifications,
    targeting_mode                     => 'Client',
    host_binaries_on_microsoft_update  => true,
    synchronize_automatically          => true,
    synchronize_time_of_day            => '06:00:00', # Every midnight ( CST )
    number_of_synchronizations_per_day => 1,
  }

  $google_projects = ['services', 'development', 'staging', 'production']

  wsusserver_computer_target_group { $google_projects:
    ensure => 'present',
  }

  wsusserver::approvalrule { 'Default Automatic Approval Rule':
    ensure          => 'absent',
    enabled         => true,
    classifications => ['Critical Updates'],
    products        => ['SQL Server'],
    computer_groups => $google_projects,
  }

  wsusserver::approvalrule { 'Automatic Approval for Security and Critical Updates Rule':
    ensure          => 'present',
    enabled         => true,
    classifications => ['Security Updates', 'Critical Updates'],
    products        => $products,
    computer_groups => $google_projects,
  }

  @@dsc_xdnsrecord { 'wsus':
    dsc_ensure => 'present',
    dsc_name   => 'wsus',
    dsc_target => "${facts['hostname']}.gccthd.com",
    dsc_type   => 'CName',
    dsc_zone   => 'gccthd.com',
  }

}
