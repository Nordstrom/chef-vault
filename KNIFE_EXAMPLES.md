# knife examples

## vault
knife vault [create|update|remove|delete] VAULT ITEM VALUES

These are the commands that are used to take data in JSON format and encrypt that data into chef-vault style encrypted data bags in chef.

* Vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* Item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* Values - This is the JSON clear text data to be stored in the vault encrypted.  This is analogous to a chef data bag item data

### create
Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver and admins admin1 & admin2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for clients role:webserver

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Create a vault called passwords and put an item called root in it with the given values for username and password encrypted for admins admin1 & admin2

    knife vault create passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Note: A JSON file can be used in place of specifying the values on the command line, see global options below for details

### update
Update the values in username and password in the vault passwords and item root.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}'

Update the values in username and password in the vault passwords and item root and add admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Update the values in username and password in the vault passwords and item root and add role:webserver to the encrypted clients.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Update the values in username and password in the vault passwords and item root and add role:webserver to the encrypted clients and admin1 & admin2 to the encrypted admins.  Will overwrite existing values if values already exist!

    knife vault update passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Add admin1 & admin2 to encrypted admins for the vault passwords and item root.

    knife vault update passwords root -A "admin1,admin2"

Add role:webserver to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -S "role:webserver"

Add admin1 & admin2 to encrypted admins and role:webserver to encrypted clients for the vault passwords and item root.

    knife vault update passwords root -S "role:webserver" -A "admin1,admin2"

Note: A JSON file can be used in place of specifying the values on the command line, see global options below for details

### remove
Remove the values in username and password from the vault passwords and item root.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}'

Remove the values in username and password from the vault passwords and item root and remove admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -A "admin1,admin2"

Remove the values in username and password from the vault passwords and item root and remove role:webserver from the encrypted clients.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver"

Remove the values in username and password from the vault passwords and item root and remove role:webserver from the encrypted clients and admin1 & admin2 from the encrypted admins.

    knife vault remove passwords root '{"username": "root", "password": "mypassword"}' -S "role:webserver" -A "admin1,admin2"

Remove admin1 & admin2 from encrypted admins for the vault passwords and item root.

    knife vault remove passwords root -A "admin1,admin2"

Remove role:webserver from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -S "role:webserver"

Remove admin1 & admin2 from encrypted admins and role:webserver from encrypted clients for the vault passwords and item root.

    knife vault remove passwords root -S "role:webserver" -A "admin1,admin2"

### delete
Delete the item root from the vault passwords

    knife vault delete passwords root

### rotate keys
Rotate the shared key for the vault passwords and item root. The shared key is that which is used for the chef encrypted data bag item.

    knife vault rotate keys passwords root

### rotate all keys
Rotate the shared key for all vaults and items. The shared key is that which is used for the chef encrypted data bag item.

    knife vault rotate all keys

### decrypt
knife vault decrypt VAULT ITEM [VALUES]

These are the commands that are used to take a chef-vault encrypted item and decrypt the requested values.

* Vault - This is the name of the vault in which to store the encrypted item.  This is analogous to a chef data bag name
* Item - The name of the item going in to the vault.  This is analogous to a chef data bag item id
* Values - This is a comma list of values to decrypt from the vault item.  This is analogous to a list of hash keys.

Decrypt the entire root item in the passwords vault and print in JSON format.

    knife vault decrypt passwords root -Fjson

Decrypt the username and password for the item root in the vault passwords.

    knife vault decrypt passwords root "username, password"

Decrypt the contents for the item user_pem in the vault certs.

    knife vault decrypt certs user_pem "contents"

### global options
<table>
  <tr>
    <th>Short</th>
    <th>Long</th>
    <th>Description</th>
    <th>Default</th>
    <th>Valid Values</th>
    <th>Sub-Commands</th>
  </tr>
  <tr>
    <td>-M MODE</td>
    <td>--mode MODE</td>
    <td>Chef mode to run in</td>
    <td>solo</td>
    <td>"solo", "client"</td>
    <td>all</td>
  </tr>
  <tr>
    <td>-S SEARCH</td>
    <td>--search SEARCH</td>
    <td>Chef Server SOLR Search Of Nodes</td>
    <td>nil</td>
    <td></td>
    <td>create, remove, update</td>
  </tr>
  <tr>
    <td>-A ADMINS</td>
    <td>--admins ADMINS</td>
    <td>Chef clients or users to be vault admins, can be comma list</td>
    <td>nil</td>
    <td></td>
    <td>create, remove, update</td>
  </tr>
  <tr>
    <td>-J FILE</td>
    <td>--json FILE</td>
    <td>JSON file to be used for values, will be merged with VALUES if VALUES is passed</td>
    <td>nil</td>
    <td></td>
    <td>create, update</td>
  </tr>
  <tr>
    <td>nil</td>
    <td>--file FILE</td>
    <td>File that chef-vault should encrypt.  It adds "file-content" & "file-name" keys to the vault item</td>
    <td>nil</td>
    <td></td>
    <td>create, update</td>
  </tr>
  <tr>
    <td>-F FORMAT</td>
    <td>--format FORMAT</td>
    <td>Format for decrypted output</td>
    <td>summary</td>
    <td>"summary", "json", "yaml", "pp"</td>
    <td>decrypt</td>
  </tr>
</table>
