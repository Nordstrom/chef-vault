# Chef-Vault
[![Gem Version](https://badge.fury.io/rb/chef-vault.png)](http://badge.fury.io/rb/chef-vault)

[![Build Status](https://travis-ci.org/Nordstrom/chef-vault.png?branch=master)](https://travis-ci.org/moserke/chef-vault)

## DESCRIPTION:

Gem that allows you to encrypt passwords and certificates using the public keys of
a list of chef nodes. This allows only those chef nodes to decrypt the 
password or certificate.

## INSTALLATION:

Be sure you are running the latest version Chef. Versions earlier than 0.10.0
don't support plugins:

    gem install chef

This plugin is distributed as a Ruby Gem. To install it, run:

    gem install chef-vault

Depending on your system's configuration, you may need to run this command with 
root privileges.

## CONFIGURATION:

## KNIFE COMMANDS:

This plugin provides the following Knife subcommands.  
Specific command options can be found by invoking the subcommand with a 
<tt>--help</tt> flag

### knife encrypt password

Use this knife command to encrypt the username and password that you want to
protect. Only Chef nodes returned by the `--search` at the time of encryption
will be able to decrypt the password.

```bash
$ knife encrypt password --search SEARCH --username USERNAME --password PASSWORD
--admins ADMINS
```

In the example below, the `mysql_user`'s password will be encrypted using the
public keys of the nodes in the `web_server` role. In addition to the servers in
the `web_server` role, Chef users `alice`, `bob`, and `carol` will also be able
to decrypt the password, an encrypted data bag item.

```bash
$ knife encrypt password --search "role:web_server" --username mysql_user
--password "P@ssw0rd" --admins "alice,bob,carol"
```

### knife decrypt password

Use this knife command to decrypt the password that is protected. This is
currently hard-coded to look for an encrypted data bag named "passwords" on the
Chef server.

    knife decrypt password --username USERNAME

### knife encrypt cert

Use this knife command to encrypt the contents of a certificate that you want to
protect. Only Chef nodes returned by the `--search` at the time of encryption
will be able to decrypt the certificate.

Typically you will decrypt the contents as part of a recipe and write them out
to a certificate on your Chef node.

```bash
$ knife encrypt cert --search SEARCH --cert CERT --password PASSWORD
--name NAME --admins ADMINS
```
 
In the example below, the `~/ssl/web_server_cert.pem` certificate will be
encrypted using the public keys of the nodes in the `web_server` role. You can
reference the name of the certificate (`web_public_key`) in a recipe when you
need to decrypt it. In addition to the servers in the `web_server` role, Chef
users `alice`, `bob`, and `carol` will also be able to decrypt the contents of
the certificate, an encrypted data bag item.

```bash
$ knife encrypt cert --search "role:web_server" --cert
~/ssl/web_server_cert.pem --name web_public_key --admins 'alice,bob,carol'
```

### knife decrypt cert

Use this knife command to decrypt the certificate that is protected. This is
currently hard-coded to look for an encrypted data bag named `certs` on the Chef
server.

    knife decrypt cert --name NAME

## USAGE IN RECIPES

To use this gem in a recipe to decrypt data you must first install the gem
via a chef_gem resource.  Once the gem is installed require the gem and then
you can create a new instance of ChefVault.

### Example Code (password)

```ruby
chef_gem "chef-vault"

require 'chef-vault'

vault    = ChefVault.new("passwords")
user     = vault.user("mysql_user")
password = user.decrypt_password
```

### Example Code (certificate)

```ruby
chef_gem "chef-vault"

require 'chef-vault'

vault    = ChefVault.new("certs")
cert     = vault.certificate("web_public_key")
contents = cert.decrypt_contents
```

## USAGE STAND ALONE

`chef-vault` can be used a stand alone binary to decrypt values stored in Chef.
It requires that Chef is installed on the system and that you have a valid
knife.rb.  This is useful if you want to mix `chef-vault` into non-Chef recipe
code, for example some other script where you want to protect a password.

It does still require that the data bag has been encrypted for the user's or
client's pem and pushed to the Chef server. It mixes Chef into the gem and 
uses it to go grab the data bag.

Do `chef-vault --help` for all available options

### Example usage (password)

  chef-vault -u Administrator -k /etc/chef/knife.rb

### Example usage (certificate)

  chef-vault -c wildcard_domain_com -k /etc/chef/knife.rb

## License and Author:

Author:: Kevin Moser (<kevin.moser@nordstrom.com>)  
Copyright:: Copyright (c) 2013 Nordstrom, Inc.  
License:: Apache License, Version 2.0  

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
