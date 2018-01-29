# Introduction
The Goal of this repository is to provide the ability to quickly spin up a puppet enterprise environment for quickly testing changes without having to touch your actual puppet enterprise server.


# Requirements
1.) Install Vagrant

2.) Install Vagrant plugins
```powershell
    > vagrant plugin install vagrant-pe_build
    > vagrant plugin install vagrant-hosts
```
NOTE: If you would like to change/update the version of PE in the vagrant file simply change the version assigned to **config.pe_build.version**


# Using the vagrant plugins
## Listing host names + private ip's
A quick way to list your machines host names and private ip's is to run the following command from the vagrant-hosts plugin that was installed earlier


```powershell
    > vagrant hosts list
```

The following can be run to generate puppet code to update your own machines hosts file to easily communicate with the nodes via their hostnames

```powershell
    > vagrant hosts puppetize | puppet apply
```

# Running puppet commands from the host machine
```powershell
    > vagrant ssh puppetmaster -c "sudo puppet node purge dc-001.attlocal.com"
```

# Using Code Manager
1.) Install Pe-Client tools on your local workstation
2.) Run the following to quickly configure PE Client tools
```powershell
    > Configure-PEClientTools.ps1
```
2.) Update your hosts file to have the following entry
```powershell
    10.20.1.2     puppetmaster.local
```
3.) Obtain a RBAC token so you can deploy environments
```powershell
    > puppet-access login --username admin
```
4.) Initiate a deployment of all environments
```powershell
    > puppet-code print-config
    > puppet-code status
    > puppet-code deploy --all --wait --log-level info
```

# Using Eyaml
First you will need to generate some encryption keys.  Simply run the following command

```powershell
    > bundle exec eyaml createkeys
```


The content you want encrypted should live in a file with the .eyaml extension.  It should initially have the unencrypted value wrapped in some markers eyaml expects to find

Example
```
---
password: DEC::PKCS7[my super secret password here]!
```

Next you can encrypt the content of a string utilizing eyaml cli
```powershell
    > bundle exec eyaml encrypt -s 'hello there bob!'
```

```data/secure.eyaml
password: >
    ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAXjA0MbZ/x+iZOnAyklysIZeYiielyRuukTPL
    CvyqKiWBWMJD3Cu3tC6N2wfjqxZ2sK/yGZqduYqamKfKx5Y7uxu3su7l/FWa
    1eyqXfM/l+KQi2RJTTYjWtg+pg+uUejN9X9tpB6zjp8yjHHTpPaRTix/9tDW
    uyGR+cbLYIXiHXhLNZ5X7CvaiBDbVSQdfkwt4/eCHJuCkrzNZ0C6FlP94610
    mMLAI345hRa/Auiwtxy0qfpKCDIrpBczEqgMZDhnJ/0tLEu4P70Uy7t08A2A
    8I+d/IyRjhoHWfOvuNH3rbwBBoqAFfTLhSb4xd+jMDYWR931PB3V3mKo6c5J
    VpeanDBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBBSoYEAbjrkCBjKEXOc
    x1a/gCCF1KRi3NMVcCErYP0RA6HgTvR51dIFnx67MeDQHNr9oA==]
```

To decrypt the eyaml file and view the contents from the command line run the following
```powershell
    > bundle exec eyaml decrypt -e .\data\secure.eyaml
```

```decrypted output
    ---
password: >
  DEC::PKCS7[hello there bob!]!
```


# Setting up master for hiera-eyaml
First you must install hiera-eyaml on the puppet server.
```powershell
    > sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml
    > service pe-puppetserver reload
```

The restart is needed in order to load this gem into puppetserver for utilization



# Encrypting the contents of a file
You can point eyaml at a file to encrypt all of its contents to be pasted into hiera.  Example
```powershell
    > bundle exec eyaml encrypt -f C:\Windows\System32\drivers\etc\hosts
```

```
hosts_file_content: >
    ENC[PKCS7,MIIFHQYJKoZIhvcNAQcDoIIFDjCCBQoCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAmBDRVh1Ti0SuVjdeeKuvkdAJDKkHSsFTeCqz
    wA53ykA3U3iqramFv0tggVIVmFgENvIkMkC0AtYOAIUvIA0Ez6RqIgVL8mck
    /nf8zrlrpA1He1veibZZkxm+v4nGp5gik6SgP94V8RgK2eJRzf++0N+TJ5bP
    y8mSjLESmAHiEwD9nv1oEEvl6MHGj3obmW3upTFxarz7Y9qSBVoPeIck3OT3
    6T4muadCjcAX568BSCPT4aInkGmOqN48xXPwP5cybnQtAP1CPsDdnA4Qqi8X
    gYOJkeRfW5Zmu9PKDiZ0CDdI1ZQgl0ScGrZegIOvqiOjEWLGI+rMDZBFZfwN
    rsXBhzCCA94GCSqGSIb3DQEHATAdBglghkgBZQMEASoEENLR68D+49dWDXC/
    Yp1B4ZuAggOw1QBd+qSWJ5stG46xGpbKUmgoJaj+YMJlbeaNFfY9eVClnjhN
    nJQirUPXlg0KHgn3rtabXS2LcVnLkd0anRziZROoaPAzkmXfha7t3AHw0C2m
    39H/QodKKopwxggqb42doUa+W650kmA4ZVn7LN3H5BQACSDscdL6ZgNDRbBO
    3hVXp7FuToqCzjSjuQd+U/gbDB2jhTHtA5GB80ZT1OoS7NAWXGwkhN2/t1BM
    LOQmaPul1Kj7G8WaokQiOVL3IByrrVp4CNjdt9v1d4K1r9Gziwnf978FLItT
    JORrE7scGBlsMBQ00hqvzqbKgs73nxiamMB5M/IkgjtrOQjgZpy9a2HrOrXj
    Z4DKAE9shGz0h3opXUVZuMHHvkvSBRb4ta1ZYkROChDCRNza5s7AwhhWiyrn
    CZgu+n9+W2Ft09fJ82yluvZ5KGOehSQ9+i2a3qWDR769ARH768pHNQaAx1NJ
    pVfCf0jZT5zTUpHblUgRrTX0XofDnnu+8fRbkNwHEV2S9gubxI+sApQv5JtH
    XgHYGLiSPxeRG8jo861TkoizOOTcrB+61Me456eHzEIc4CPEO/TRYmaILjYu
    yUB8ctq0Y5yPl9jghwWKu5j9R33cGlLZTBgoGaNojWegZ4FwnBK0hicKu836
    yefYMAzAMcO4ZS9qHwB86fhD0L4Y869dWSWFQHX3Hhh35LGeWk6zpAwcnn8g
    +3KOrsOGV1FeyRLlbDF9ep9Pcs/9jMatYCptg9cLH/rvVkYF45d4ALvgudEu
    H/bwGUCDh1V1S5C5etueIoCXZr1gZqQrwWAaYg43YKf1MCj5IHFmgwtr5Tml
    tv2Vt9hh0+Nyj0J7+gzjcx6iDrOd9Lcy3elnVQl6AAD5jUYKVzxs4wqXHHmH
    bNwiNE6dvY1JLjz4SccD0paCcBFT/5q56yGyOaqJDMNYVYX+KM1SKPcvjwR7
    HHAavI4a9t05VH0/stiGeDS77ZMutXQA17xpAy0JAjKj5ay8WhLr8ds7aXtp
    8rfTf8sVONtK7BmgwuyHHrk7bj9hEx8O96L3QqHRK0lvRtr9xQ5pdSQ9ggp7
    8JBKLkOYjACIFskQhXP2gmEpIvqGKWVNVOAXgS116rMVxZwj/9iz84Nvoi6k
    6gtOimkiCo5QzV9JiaUI3+ppXi/qL454LiEy9iSNSKbPOVFjROZH/7H/oQE4
    7yjjkiED7kWN4NQ052Q+ncpcIT+HngnQ+WN4Lx9VPEcUA4lGWYpIkZd1+rMn
    Ee1h5kT3aV0=]
```

# Encrypting a password
If you don't want the password to be visible from your screen as you encrypt something use the following ot be prompted for the password
```powershell
    > bundle exec eyaml encrypt -p
```

# label
By default when you encrypt something the hiera key is called 'block' to auto create the label so it's a straight copy and paste from stdout to hiera do the following
```powershell
    > bundle exec eyaml encrypt -l 'some_easy_to_use_label' -s 'yourSecretString'
```

```
some_easy_to_use_label: >
    ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAmdDNxHOjsajuh0KXJFiEh1OuPq3HvIhaoDfx
    28sNWf/3Gy0fzSmbciKUqrpEneZtB7pBs9G7hXIqr+vpcG0uj6wmme5ioA2r
    oIe2CZZeapXCdi6+zghABYA8Vtx/B/ZhEzFEHBMV28ipAl45EB2wimR9M8dH
    L6Das7BjmOMOXwEu9MIubs6QmzXE0dNHxPa1ldDPT4+nzCjLcSLj88c0M2uK
    pRU9IZQjcXor3cbrkEzoJZcMUxXXM/UPlXgtu1OmhlcTK3yvxoWkFBoTLgyL
    k/tXSteG0boeOaHkJ3UOzfcWGWLVHZ/+FCuw3FK+34mgLi4IpyAzvn4KJEkR
    U0/ptTBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBB/imFWp4D9XOu6T50u
    9Z/4gCB8t4dl5bFy/OEDxKMRf6eCTFh77DfhdamKWvEK94l52g==]
```

# TODO: Hook up vault hiera backend
https://github.com/jsok/hiera-vault

# Connecting to vault
```powershell
> $env:VAULT_ADDR = 'http://10.20.1.13:8200'
> vault.exe write secret/hello key=world
```

# How can I avoid download fixtures dependencies every time I run `bundle exec rake spec`?
```powershell
    > bundle exec rake spec_prep
    > bundle exec rake spec_standalone
```


# Testing hiera lookup on your local developerbox
```powershell
  > bundle exec puppet lookup --hiera_config .\hiera.yaml 'profile::domainbase::domain_name'
```

# Graphite
http://10.20.1.12


# Grafana
http://10.20.1.12:3000
1.) Create datasource that points the local graphite server to pull in puppetserver stats

Url : http://localhost
Access : proxy

# Query puppetdb from inside manifest
Puppet enterprise provides a function that is already ready to be used to query puppetdb and pull data out from within a manifest

```powershell
  $windows_nodes_query = 'nodes[certname]{facts{name = "operatingsystem" and value = "windows"}}'
  $windows_nodes = puppetdb_query($windows_nodes_query).each |$value| { $value["certname"] }
  notify {'windows nodes':
      message => "Your windows nodes are ${join($windows_nodes, ', ')}",
  }
  ```

  NOTE: I didn't any any modules or configure anything.  This worked straight up out of the box for puppet enterprise 2017.2.2


  # Pry Debugging
  To start debugging just put a breakpoint anywhere in your ruby code where you want to stop execution at
  ```
    require 'pry'; binding.pry
  ```

  It's easy to get lost or forget where you are @ in the code so to let pry tell you you can run the following command
```
    > whereami
```

View the stack
```
    > show-stack
```

Stepping through the code
Move to next line
```
    > next
```

step into a function
```
    > step
```

Continue execution
If you want to continue execution to the end of the program or to next available breakpoiont simply run the following command
```
    > continue
```


Completely exit out of the debugger and program
```
    > exit!
```


# Quick way to get into a IRB console
A quick way to get into an IRB console to play around with ruby code is to use pry by executing the following
```
    > bundle exec pry
```


# Upload local files to the guest vm via vagrant winrm
```
> vagrant winrm-upload 'C:\vox\puppet-windowsfeature' 'C:\ProgramData\Puppetlabs\code\modules' dc-001
```

# Possible Issues with vagrant
https://github.com/hashicorp/vagrant/issues/8785