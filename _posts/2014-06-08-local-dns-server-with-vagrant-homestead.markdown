---

layout: post_simple
title: Local Dns Server With Vagrant Homestead
permalink: post/local-dns-server-with-vagrant-homestead
excerpt: "I've been using [Laravel Homestead](http://laravel.com/docs/homestead#introduction) for a while now, many thanks to Taylor for making life so much easier. If you are using Homestead your usual workflow might be something along the lines of _Creating new laravel app > Adding site entry in `Homestead.yaml` file > Adding domain into `/etc/hosts` file_ and then get to work.  
Everything is pretty simple except managing the `/etc/hosts` file. Really, I never wanted to add more and more domains into it without having any idea about which domain is still required and which is no longer in business. This is when I decided to let Homestead manage all those domains for me.

"

date: 2014-06-08

tags: 
  - "DNS"
  - "Homestead"
  - "Tips"
  - "Vagrant"

---

I've been using [Laravel Homestead](http://laravel.com/docs/homestead#introduction) for a while now, many thanks to Taylor for making life so much easier. If you are using Homestead your usual workflow might be something along the lines of _Creating new laravel app > Adding site entry in `Homestead.yaml` file > Adding domain into `/etc/hosts` file_ and then get to work.  
Everything is pretty simple except managing the `/etc/hosts` file. Really, I never wanted to add more and more domains into it without having any idea about which domain is still required and which is no longer in business. This is when I decided to let Homestead manage all those domains for me.




Long story short, I installed `Dnsmasq` on Homestead and added it as a DNS on host machine, now all the domain entries are stored on Homestead virtual machine and I can take care of business without worrying about pesky domain mappings.

Here is how you can set up a basic DNS for your applications.  

Before setting up everything else you'll need to make a change in your _Homestead_ `Vagrantfile`, open up the `Vagrantfile` and make sure it looks like this

```ruby
VAGRANTFILE_API_VERSION = "2"

path = "#{File.dirname(__FILE__)}"

require 'yaml'
require path + '/scripts/homestead.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # comment out the default line like this below
  # Homestead.configure(config, YAML::load(File.read(path + '/Homestead.yaml')))
  
  preferences = YAML::load(File.read(path + '/Homestead.yaml'))
  # run default Homestead provision
  Homestead.configure(config, preferences)

# remove existing hosts file if any
  config.vm.provision "shell" do |shell|
    shell.inline = "rm $1"
    shell.args = ["/home/vagrant/hosts"]
  end

  # add custom provision script to populate domain mapping
  preferences["sites"].each do |site|
    config.vm.provision "shell" do |shell|
    
      # populate the domain mapping file from Homestead sites configuration
      # the dot after $2 is important
      shell.inline = "echo $1  $2. >> /home/vagrant/hosts"
      shell.args = [preferences["ip"], site["map"]]
    end
  end

end
```

This will take all the `Sites` entries defined in `Homestead.yaml` file and use those domains to populate a domain mapper file much like `/etc/hosts` file  

Now `vagrant up` and SSH into Homestead and install `dnsmasq` by running

```sh
sudo apt-get install dnsmasq
```

Now with that installed you need to set a couple things up.  

open `/etc/dnsmasq.conf` file in your editor of choice and clear it out, then add this configuration to file

```
domain-needed
bogus-priv

# define local domain part
# this will allow you to have domains with .app extension,
# so make sure all your development apps are using .app as extension,
# e.g. somedomain.app, myapp.app
local=/app/
domain=app

# listen on both local machine and private network
listen-address=127.0.0.1
listen-address=192.168.10.10

# read domain mapping from this file as well as /etc/hosts
addn-hosts=/home/vagrant/hosts
expand-hosts
```

save and close the file.  
Now restart `dnsmasq` by running

```sh
sudo service dnsmasq restart
```

and you are set.

Now log out of Homestead and make one last change on your machine. This is the time to let our host machine know about new DNS server on the network.

### Set up Mac
I added new DNS by going to __Network Connection Icon > Open Network Preferences > Active Connection (From Left Pane) > Advanced > DNS (Tab)__. 

Then in left pane add these IPs by clicking the <kbd>+</kbd> button

```
192.168.10.10
8.8.8.8
8.8.4.4
```

Click __Ok__ and __Apply__

### Set up Linux
On my Linux the process was going to __Network manager icon > Edit Connecions... > Select active connection > Edit... > IPv4 settings (Tab).__ 

Then in __Additional DNS servers__ enter the DNS servers separated by comma:

```
192.168.10.10,8.8.8.8,8.8.4.4
```

and click __Save__

### Set up Windows
Please install Linux and follow the instructions from Linux section

And you're now good to go. Here, the first IP is our local DNS running on Homestead machine and rest two are Google's DNS. Now every time you make a request to open any site these DNS will be queried in same order as defined. Homestead DNS will be queried first, and if it is offline other two will be queried.

Now lets just perform a quick check to make sure things are working as they should be, grab a domain from `Homestead.yaml` file and open up a terminal on hot machine. Now run 

```
dig yourdomain.app
```

It should output some details about the domain which should look like this

```
; <<>> DiG 9.8.3-P1 <<>> yourdomain.app
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28778
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;yourdomain.app.		IN    A

;; ANSWER SECTION:
yourdomain.app.	0	IN	    A    192.168.10.10

;; Query time: 46 msec
;; SERVER: 192.168.10.10#53(192.168.10.10)
;; WHEN: Sun Jun  8 15:23:41 2014
;; MSG SIZE  rcvd: 54
```

Notice the fourth line which says

```
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28778
```

If you did everything correct it should say `status: NOERROR` if it says `status: NXDOMAIN` that means the domain cannot be resolved to any IP address. And finally the answer section should show the IP address of Homestead machine

```
;; ANSWER SECTION:
yourdomain.app.	0	IN	    A    192.168.10.10
```

If anything goes wrong just try to restart `dnsmasq` by running 

```
sudo service dnsmasq restart
```
    
and see if that resolves the issue, otherwise feel free to post your `/etc/dnsmasq.conf` file in comment and I'll try to help.

Open up your browser and go to __yourdomain.app__, you should see Laravel greetings.  
Enjoy the freedom.