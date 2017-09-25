# Class: profile::linux::grafanaserver
#
#
class profile::linux::grafanaserver {

    notify { 'hello world!': }
    class { 'graphite': }
    class { 'grafana':
      install_method => 'package',
      package_source => 'https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.4.1_amd64.deb',

      cfg            => {
            # Configuration settings for /etc/grafana/grafana.ini.
            # See <http://docs.grafana.org/installation/configuration/>.

            # Only listen on loopback, because we'll have a local Apache
            # instance acting as a reverse-proxy.
            'server' => {
                http_addr => '0.0.0.0',
                http_port => '3000',
                protocol  => 'http',
            },
        }
    }


  grafana_datasource { 'graphite':
    ensure           => present,
    type             => 'graphite',
    url              => 'http://localhost:80',
    access_mode      => 'proxy',
    is_default       => true,
    grafana_url      => 'http://localhost:3000',
    grafana_user     => 'admin',
    grafana_password => 'admin',
  }

  grafana_dashboard { 'puppetmaster-stats':
    grafana_url      => 'http://localhost:3000',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => file('profile/linux/grafanaserver/puppetmaster-metrics-dashboard.json'),
  }

    Class['graphite']
    -> Class['grafana']
    -> Grafana_datasource['graphite']
    -> Grafana_dashboard['puppetmaster-stats']
}