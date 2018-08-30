class profile::linux::jenkins::slave(
  String[1] $autojoiner_username,
  Sensitive[String[1]] $sensitive_autojoiner_password,
) {

  class { 'jenkins::slave':
      masterurl                => 'http://jenkinsmaster-001.local:4440',
      ui_user                  => $autojoiner_username,
      ui_pass                  => $sensitive_autojoiner_password.unwrap(),
      slave_name               => $facts['hostname'],
      labels                   => ['control-repo'],
      executors                => 8,
      disable_ssl_verification => true,
      install_java             => true,
      manage_client_jar        => true,
  }
}
