# Class: profile::linux::squidproxy
#
#
class profile::linux::squidproxy {
  include squid

  squid::http_port{'3128':
  }

  squid::acl{'gcp_metadata':
    type    => dst,
    entries => ['169.254.169.254'],
  }

  squid::http_access{ 'gcp_metadata':
    action => deny,
  }

  squid::acl{'localnet':
    type    => src,
    entries => ['10.43.192.0/18'],
  }

  squid::http_access{ 'localnet':
    action => allow,
  }

  squid::http_access{ 'all':
    action => deny,
  }

  concat::fragment{ 'squid_conf_cache_deny_all':
    target  => '/etc/squid/squid.conf',
    content => 'cache deny all',
    order   => '65535-01', # Place at the end of the file
  }

}