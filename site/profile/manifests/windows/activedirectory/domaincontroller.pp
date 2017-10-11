# This class is used to install a new active directory domaincontroller.
#
# This class should not be called directly, but rather is used by our roles.
#
# @param domain_name [String] The new domain you're creating.
# @param domain_net_bios_name [String[1, 15]] The domain's net bios name.
# @param safe_mode_administrator_password [String] The password for booting the domaincontroller into recovery mode.
# @param domain_administrator_user [String] The user for the domain administrator account for the domain.
# @param domain_administrator_password [String] The password for the domain administrator account for the domain.
#
class profile::windows::activedirectory::domaincontroller(
  Pattern[/\./] $domain_name,
  String[1, 15] $domain_net_bios_name,
  String $safe_mode_administrator_password,
  String $domain_administrator_user,
  String $domain_administrator_password,
  Boolean $is_first_dc,
  Optional[Pattern[/^\d+\.\d+\.\d+\.\d+$/]] $first_dc_internal_ipv4_address = undef,
) {

  redact('safe_mode_administrator_password')
  redact('domain_administrator_password')

  dsc_windowsfeature { 'RSAT-ADDS':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-ADDS',
  }

  dsc_windowsfeature { 'AD-Domain-Services':
    dsc_ensure => 'present',
    dsc_name   => 'AD-Domain-Services',
  }

  if ($is_first_dc) {

    dsc_xaddomain { $domain_name:
      ensure                            => 'present',
      dsc_domainname                    => $domain_name,
      dsc_safemodeadministratorpassword => {
        'user'     => 'this is ignored', # this is ignored...... its a PSCredential thing...
        'password' => Sensitive($safe_mode_administrator_password),
      },
      # NOTE:
      # The domain credentials are not used/utilized if this is the first domain in a new forest.  These are only actually used
      # when your creating a child domain and want to join the child domain to the parent domain.
      dsc_domainadministratorcredential => {
        'user'     => $domain_administrator_user,
        'password' => Sensitive($domain_administrator_password),
      },
      dsc_domainnetbiosname             => $domain_net_bios_name, # 15 character limit...
      dsc_databasepath                  => 'C:\\Windows\\NTDS',
      dsc_logpath                       => 'C:\\Windows\\NTDS',
      dsc_sysvolpath                    => 'C:\\Windows\\SYSVOL',
      require                           => Dsc_windowsfeature['AD-Domain-Services'],
      notify                            => Reboot['new_domain_controller_reboot'],
    }
    # TODO: pick Ethernet 2 when running inside virtualbox
    dsc_xdnsserveraddress { 'DnsServerAddresses':
      ensure             => 'present',
      dsc_address        => '127.0.0.1',
      dsc_interfacealias => 'Ethernet 2',
      dsc_addressfamily  => 'IPv4',
      dsc_validate       => true,
    }
  } else {

    # TODO: Install additional domaincontroller to our domain

    dsc_xdnsserveraddress { 'DnsServerAddresses':
      ensure             => 'present',
      dsc_address        => [ $first_dc_internal_ipv4_address ],
      dsc_interfacealias => $facts['networking']['primary'],
      dsc_addressfamily  => 'IPv4',
      # dsc_validate       => true,
    }

    # TODO: Should we have code to wait for the domain to exist before adding an additional domain controller?
    # xWaitForADDomain DscForestWait
    # {
    #     DomainName = $Node.DomainName
    #     DomainUserCredential = $domainCred
    #     RetryCount = $Node.RetryCount
    #     RetryIntervalSec = $Node.RetryIntervalSec
    #     DependsOn = "[WindowsFeature]ADDSInstall"
    # }

    dsc_xaddomaincontroller { 'Additional Domain Controller':
      ensure                            => 'present',
      dsc_domainname                    => $domain_name,
      dsc_safemodeadministratorpassword => {
        'user'     => 'this is ignored', # this is ignored...... its a PSCredential thing...
        'password' => Sensitive($safe_mode_administrator_password),
      },
      # NOTE:
      # The domain credentials are not used/utilized if this is the first domain in a new forest.  These are only actually used
      # when your creating a child domain and want to join the child domain to the parent domain.
      dsc_domainadministratorcredential => {
        'user'     => $domain_administrator_user,
        'password' => Sensitive($domain_administrator_password),
      },
      dsc_databasepath                  => 'C:\\Windows\\NTDS',
      dsc_logpath                       => 'C:\\Windows\\NTDS',
      dsc_sysvolpath                    => 'C:\\Windows\\SYSVOL',
      # dsc_sitename                    => 'HOUSTON',
      require                           => Dsc_windowsfeature['AD-Domain-Services'],
      notify                            => Reboot['new_domain_controller_reboot'],
    }

  }

  reboot { 'new_domain_controller_reboot':
    apply   => 'immediately',
    message => 'New domain controller installed and is causing a reboot since one is pending',
  }

  # TODO Export a resource with the domain information so that other resources can figure out how to join the domain correctly.
  # @@host { $facts['fqdn']:
  #     #host_aliases =< [],
  #     ip           => $facts['networking']['ip'],
  # }
  # Host <<| |>>

}
