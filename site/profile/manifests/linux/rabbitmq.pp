# Class: profile::linux::rabbitmq
#
#
class profile::linux::rabbitmq {

  class { 'rabbitmq':
    admin_enable      => true,
    management_port   => 15672,
    port              => 5672,
    delete_guest_user => true,
    service_manage    => true,
    service_ensure    => 'running',
    rabbitmq_user     => 'rabbitmq',
    rabbitmq_group    => 'rabbitmq',
  }

  rabbitmq_user { 'administrator':
    ensure   => 'present',
    admin    => true,
    password => Sensitive('administrator'),
  }
}
