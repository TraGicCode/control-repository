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
    extra_parameters => [ '--restart=always' ],
  }
}
