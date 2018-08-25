source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 5.5.0']
gem 'metadata-json-lint'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'
gem 'guard-rake'
gem 'ra10ke'
gem 'generate-puppetfile'
gem 'beaker'
gem 'beaker-puppet_install_helper'
gem 'beaker-rspec'
gem 'beaker-pe'
gem 'hiera-eyaml'
gem 'mdl' # markdown linting

# Debugging tools
gem 'pry'                # Prey Debugger: Consle driven debugger.  Stops the execution in the middle of a call to allow inspection of ruby variables
gem 'pry-byebug'         # Pry Plugin: used to step through the code
gem 'pry-stack_explorer' # Pry Plugin: used to step through the code.  Shows how you got to where you are now and the variables at each point in the stack
gem 'pry-rescue'         # Pry Plugin: used to break when an exception is thrown

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'
  gem 'rubocop-rspec'
end
