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
    volumes          => ['jenkins_home:/var/jenkins_home'],
    hostentries      => ['puppetmaster-001.local:10.20.1.2'],
    # This keeps it trying to start if it fails the first and so on.
    extra_parameters => [ '--restart=always' ],
  }
}
