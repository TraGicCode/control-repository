class profile::windows::activedirectory::joindomain(
  String $domain_name,
  String $domain_join_username,
  String $domain_join_password,
  String $domain_join_ou,
) {

  redact('domain_join_password')

  dsc_xcomputer { "Join ${domain_name} domain":
    dsc_name       => $facts['hostname'],
    dsc_domainname => $domain_name,
    dsc_joinou     => $domain_join_ou,
    dsc_credential => {
      'user'     => $domain_join_username,
      'password' => Sensitive.new($domain_join_password),
    },
  }

  reboot { 'computer_join_domain_reboot':
    apply     => finished,
    subscribe =>  Dsc_xcomputer["Join ${domain_name} domain"],
  }
}
