# Vagrant IIJ GIO Provider

This is a [Vagrant](http://www.vagrantup.com) 1.3+ plugin that adds a IIJGP provider to Vagrant,
allowing Vagrant to control and provision VMs in IIJ GIO Hosting package service.

## Features

-   Boot Virtual Machines in IIJ GIO Hosting package service
-   SSH into the VMs.
-   Provision the VMs with the Chef provisioner.
-   Supports synced folder via `rsync`.
-   Do some tweaks for IIJ CentOS VM
    -   disabling `Default requiretty` sudo settings for the root user.

## Usage

Install using standard Vagrant 1.1+ plugin installation methods.
After installing, `vagrant up` and specify the `iijgp` provider.
An example shown below.

~~~~ {.shell}
$ vagrant plugin install vagrant-iijgp
...
$ vagrant up --provider=iijgp
...
~~~~

Of course prior to doing this, you'll need to obtain a iijgp-compatible box file for Vagrant.

## Quick Start

After installing the plugin (instructions above),
the quickest way to get started is to actually use a dummy IIJGP box
and specify all the details manually within a `config.vm.provider` block.
So first, add the dummy box using any name you want:

~~~~ {.shell}
$ vagrant box add dummy https://github.com/iij/vagrant-iijgp/raw/master/dummy.box
....
~~~~

And then make a Vagrantfile that looks like the following,
filling in your informathion where necessary.

~~~~ {.ruby}
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :iijgp do |iijgp, override|
    iijgp.access_key = "YOUR ACCESS KEY"
    iijgp.secret_key = "YOUR SECRET KEY"
    iijgp.gp_service_code = "gpXXXXXXXX"
    iijgp.ssh_public_key = "YOUR PUBLIC SSH KEY"

    override.ssh.username = "root"
    override.ssh.private_key_path = "#{ENV['HOME']}/.ssh/id_rsa"
  end

  config.vm.define "vm1" do |c|
    c.vm.provider :iijgp do |iijgp|
      iijgp.gc_service_code = "gcXXXXXXXX"
    end
  end
end
~~~~

And then run `vagrant up --provider=iijgp vm1`.

This will start the VM which is already created and specified with
the service code "gcXXXXXXXX" in GP "gpXXXXXXXX".
And if your SSH information was filled in properly,
SSH and provisioning will work as well.

If you always use iijgp provider as default, please set it in your shell setting:
~~~~ {.shell}
export VAGRANT_DEFAULT_PROVIDER=iijgp
~~~~
then you can simply run `vagrant up` with iijgp provider.

## Box Format

Every provider in Vagrant must introduce a custom box format.
This provider introduce `iijgp` boxes.
You can view an example box in the example_box/ directory.

## Configuration

There are some provider specific configuration option to control IIJ GIO VMs:

-   mandatory parameters
    -   `access_key` - The access key for manipulating IIJ API.
    -   `secret_key` - The secret key for manipulating IIJ API.
    -   `gp_service_code` - The gp service code to launch the VMs.
    -   `ssh_public_key` - The SSH public key content to accessing IIJ VMs.
        This is used only for the first start up of the VM.
        If you intend to change the SSH key, you should initialize virtual machine.
        (Or, call ImportRootSshPublicKey API manually...)
-   optional parameters
    -   `label` - The label for the VM. If it is missing, the vagrant VM name will be used.
    -   `virtual_machine_type` - The type of virtual machine. This setting is only required if you want to add a new VM contract.
    -   `os` - The operating system. If you intend to use Chef provisioner, you need to use a kind of CentOS6 images.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
