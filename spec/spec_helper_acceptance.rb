require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

hosts.each do |host|
  run_puppet_install_helper
  # Install module dependencies
  on host, puppet('module', 'install', 'puppetlabs-stdlib')
  on host, puppet('module', 'install', 'puppet-squid')
  on host, puppet('module', 'install', 'puppetlabs-chocolatey')
  on host, puppet('module', 'install', 'puppetlabs-dsc')
end

RSpec.configure do |c|
  profile_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'site', 'profile'))
  c.formatter = :documentation

  c.before :suite do
    # Install module
    puppet_module_install(source: profile_dir, module_name: 'profile')
  end
end
