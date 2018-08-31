# Find PE Versions here
# http://versions.puppet.com.s3-website-us-west-2.amazonaws.com/
PE_VERSION = '2018.1.4'

# Way to install vagrant plugins automatically on vagrant up
# required_plugins = %w(vagrant-reload)
# plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
# if not plugins_to_install.empty?
#   puts "Installing plugins: #{plugins_to_install.join(' ')}"
#   if system "vagrant plugin install #{plugins_to_install.join(' ')}"
#     exec "vagrant #{ARGV.join(' ')}"
#   else
#     abort "Installation of one or more plugins has failed. Aborting."
#   end
# end


Vagrant.configure('2') do |config|
  config.pe_build.version = PE_VERSION
  config.pe_build.download_root = "https://s3.amazonaws.com/pe-builds/released/#{PE_VERSION}"

  config.vm.define :puppetmaster do |node|
    node.vm.hostname = 'puppetmaster-001.local'
    node.vm.network :private_network, :ip => '10.20.1.2'
    node.vm.box = 'puppetlabs/ubuntu-16.04-64-nocm'
    node.vm.synced_folder ".", "/vagrant"
    node.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_bootstrap do |p|
      p.role = :master
    end

    node.vm.provision "shell", inline: <<-SHELL
          # disable firewall to allow access to enterprise console web ui
          sudo ufw disable

          # Setup puppet server to handle hiera-eyaml
          sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml
          sudo mkdir -p /etc/puppetlabs/puppet/keys/
          sudo cp /vagrant/keys/* /etc/puppetlabs/puppet/keys/
          sudo chown pe-puppet:pe-puppet /etc/puppetlabs/puppet/keys/*
          
          sudo puppet module install puppetlabs-stdlib
          sudo puppet module install WhatsARanjit-node_manager --version 0.7.1
          sudo puppet apply /vagrant/PuppetMaster.pp --debug
          
          sudo puppet agent --test
          sudo puppet agent --test

          # Automate first codemanager deploy
          sudo echo 'puppetlabs' | puppet access login --username admin
          puppet code deploy --all --wait
    SHELL
  end

  config.vm.define :windowsagent1 do |node|
    node.vm.hostname = 'winagent-001'
    node.vm.network :private_network, :ip => '10.20.1.3'
    node.vm.box = 'mwrock/Windows2016'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1
    POWERSHELL
  end

  config.vm.define :windowsagent2 do |node|
    node.vm.hostname = 'winagent-002'
    node.vm.network :private_network, :ip => '10.20.1.4'
    node.vm.box = 'mwrock/Windows2016'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1
    POWERSHELL
  end

  config.vm.define :linuxagent1 do |node|
    node.vm.hostname = 'linuxagent-001.local'
    node.vm.network :private_network, :ip => '10.20.1.5'
    node.vm.box = 'puppetlabs/ubuntu-16.04-64-nocm'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
      v.memory = 4096
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
  end

  config.vm.define :linuxagent2 do |node|
    node.vm.hostname = 'linuxagent-002.local'
    node.vm.network :private_network, :ip => '10.20.1.6'
    node.vm.box = 'puppetlabs/ubuntu-16.04-64-nocm'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
  end



  config.vm.define 'devnode' do |node|
    node.vm.hostname = 'devnode-001'
    node.vm.network :private_network, :ip => '10.20.1.7'
    node.vm.box = 'mwrock/Windows2016'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1 extension_requests:pp_environment=development
    POWERSHELL
  end

  config.vm.define 'stagingnode' do |node|
    node.vm.hostname = 'stagingnode-001'
    node.vm.network :private_network, :ip => '10.20.1.8'
    node.vm.box = 'mwrock/Windows2016'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1 extension_requests:pp_environment=staging
    POWERSHELL
  end

  config.vm.define 'productionnode' do |node|
    node.vm.hostname = 'productionnode-001'
    node.vm.network :private_network, :ip => '10.20.1.9'
    node.vm.box = 'mwrock/Windows2016'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1 extension_requests:pp_environment=production
    POWERSHELL
  end

  config.vm.define 'dc-001' do |node|
    node.vm.hostname = 'dc-001'
    node.vm.network :private_network, :ip => '10.20.1.10'
    node.vm.box = 'tragiccode/windows-2016-standard'
    node.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.linked_clone = true
      v .customize ["modifyvm", :id, "--vram", 48]
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision "shell", inline: <<-POWERSHELL
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
    $webClient = New-Object System.Net.WebClient;
    $webClient.DownloadFile('https://puppetmaster-001.local:8140/packages/current/install.ps1', 'install.ps1');
    .\\install.ps1
    POWERSHELL
  end

  config.vm.define 'jenkinsmaster-001' do |node|
    node.vm.hostname = 'jenkinsmaster-001.local'
    node.vm.network :private_network, :ip => '10.20.1.13'
    node.vm.box = 'puppetlabs/ubuntu-16.04-64-nocm'
    node.vm.provider "virtualbox" do |v|
      v.linked_clone = true
    end
    node.vm.provision :hosts, :sync_hosts => true
    node.vm.provision :pe_agent do |p|
      p.master_vm = 'puppetmaster'
    end
  end


end
