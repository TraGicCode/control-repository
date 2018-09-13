class profile::windows::chocolatey::simple_server {


  class { 'chocolatey_server':
    port => '8080',
  }

}
