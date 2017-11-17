class profile::windows::activedirectory::joindomain(
  String $domain_join_username,
  String $domain_join_password,
  String $domain_join_ou,
  Pattern[/\./] $domain_name = $profile::windows::activedirectory::data::domain_name,
) inherits profile::windows::activedirectory::data {

  redact('domain_join_password')

  dsc_xcomputer { "Join ${domain_name} domain":
    dsc_name       => $facts['hostname'],
    dsc_domainname => $domain_name,
    dsc_joinou     => $domain_join_ou,
    dsc_credential => {
      'user'     => $domain_join_username,
      'password' => $domain_join_password,
    },
  }

  reboot { 'computer_join_domain_reboot':
    apply     => finished,
    subscribe =>  Dsc_xcomputer["Join ${domain_name} domain"],
  }
}
