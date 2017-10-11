# Definition:
# Member servers are servers running within a domain. 
# Member sever runs an operating system which belongs to a domain and is not a DC. 
# Member server typically run different services on the machine can act like a file server web server application server print server.
# Class: profile::windows::domainmemberserver
#
#
# TODO: Look at making the dc ip addresses not hardcoded?
class profile::windows::activedirectory::domainmemberserver(
  Pattern[/\./] $domain_name,
  String $domain_join_username,
  String $domain_join_password,
  # String $domain_join_ou,
) {

  dsc_xcomputer { "join ${domain_name} domain":
    ensure         => 'present',
    dsc_name       => $facts['hostname'],
    dsc_domainname => $domain_name,
    dsc_credential => {
        'user'     => $domain_join_username,
        'password' => Sensitive($domain_join_password),
    },
    notify         => Reboot['new_domain_member_server'],
  }

  reboot { 'new_domain_member_server':
    apply   => 'immediately',
    message => "Joined server to the ${domain_name} domain and is causing a reboot since one is pending",
  }
}
