# Class: profile::linux::jenkinsmaster
#
#
class profile::linux::jenkinsmaster {

  include ::docker

  docker::image { 'jenkinsci/blueocean':
    ensure    => present,
    image_tag => 'latest',
  }

  docker::run { 'jenkins_demo':
    image            => 'jenkinsci/blueocean:latest',
    ports            => ['8080:8080','50000:50000'],
    hostentries      => ['puppetmaster-001.local:10.20.1.2'],
    # This allows us to manage it with puppet without having to blow away the container
    # on every change to this resource
    extra_parameters => [ '--restart=always' ],
  }
}
