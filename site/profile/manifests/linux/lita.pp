# Class: profile::linux::lita
#
#
class profile::linux::lita {

  include rvm
  rvm_system_ruby { 'ruby-2.0':
    ensure      => 'present',
    default_use => true;
  }

  rvm_gem { 'ruby-2.0/bundler':
    ensure  => 'present',
    require => Rvm_system_ruby['ruby-2.0'];
  }

  include redis

  # This should be a template
  file { '/home/vagrant/lita':
    ensure => 'directory',
  }
  file { '/home/vagrant/lita/Gemfile':
    ensure  => 'file',
    content => 'source "https://rubygems.org"
                gem "lita"
                gem "lita-slack"',
    require => File['/home/vagrant/lita'],
  }

  exec { 'install-lita-gems':
    command     => 'bundle install --path .bundle',
    cwd         => '/home/vagrant/lita',
    path        => ['/usr/local/rvm/gems/ruby-2.0.0-p648/bin', '/usr/local/rvm/gems/ruby-2.0.0-p648@global/bin', '/usr/local/rvm/rubies/ruby-2.0.0-p648/bin', '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rvm/bin'],
    logoutput   => true,
    environment => ['GEM_PATH=/usr/local/rvm/gems/ruby-2.0.0-p648:/usr/local/rvm/gems/ruby-2.0.0-p648@global'],
  }

  file { '/home/vagrant/lita/lita_config.rb':
    ensure  => 'file',
    content => 'Lita.configure do |config|
                  config.robot.name = "Lita"

                  config.robot.log_level = :info
                  config.robot.admins = ["U1G4YD4HY"]
                  # appropriate gem to the Gemfile.
                  # config.robot.adapter = :shell
                  
                  config.robot.adapter = :slack
                  config.adapters.slack.token = "xoxb-244674932694-jFTq1lDhAJw2Z1neo0X5oRmC"

                  ## Example: Set options for the chosen adapter.
                  # config.adapter.username = "myname"
                  # config.adapter.password = "secret"

                  ## Example: Set options for the Redis connection.
                  # config.redis.host = "127.0.0.1"
                  # config.redis.port = 1234

                  ## documentation for options.
                  # config.handlers.some_handler.some_config_key = "value"
                end',
    require => File['/home/vagrant/lita'],
  }
  # https://github.com/litaio/chef-lita/blob/master/templates/default/lita.erb
  systemd::unit_file { 'lita.service':
    content => '[Unit]
Description=My Lita instance
Requires=redis.service
After=redis.service

[Service]
Environment=HOME=/home/vagrant
TimeoutStartSec=0
WorkingDirectory=/home/vagrant/lita
ExecStart=/bin/bash -lc "bundle exec lita start"
ExecStop=/bin/bash -lc "bundle exec lita stop"

[Install]
WantedBy=multi-user.target',
  }

}