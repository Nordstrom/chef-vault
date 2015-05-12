require 'json'

Given(/^I create a vault item '(.+)\/(.+)' containing the JSON '(.+)' encrypted for '(.+)'(?: with '(.+)' as admins?)?$/) do |vault, item, json, nodelist, admins|
  write_file 'item.json', json
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  adminarg = admins.nil? ? '-A admin' : "-A #{admins}"
  run_simple "knife vault create #{vault} #{item} -z -c knife.rb #{adminarg} -S '#{query}' -J item.json", false
end

Given(/^I update the vault item '(.+)\/(.+)' to be encrypted for '(.+)'( with the clean option)?$/) do |vault, item, nodelist, cleanopt|
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  run_simple "knife vault update #{vault} #{item} -z -c knife.rb -S '#{query}' #{cleanopt ? '--clean' : ''}"
end

Given(/^I remove clients? '(.+)' from vault item '(.+)\/(.+)' with the '(.+)' options?$/) do |nodelist, vault, item, optionlist|
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault remove #{vault} #{item} -z -c knife.rb -S '#{query}' #{options}"
end

Given(/^I rotate the keys for vault item '(.+)\/(.+)' with the '(.+)' options?$/) do |vault, item, optionlist|
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault rotate keys #{vault} #{item} -c knife.rb -z #{options}"
end

Given(/^I rotate all keys with the '(.+)' options?$/) do |optionlist|
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault rotate all keys -z -c knife.rb #{options}"
end

Given(/^I refresh the vault item '(.+)\/(.+)'$/) do |vault, item|
  run_simple "knife vault refresh #{vault} #{item} -c knife.rb -z"
end

Given(/^I refresh the vault item '(.+)\/(.+)' with the '(.+)' options?$/) do |vault, item, optionlist|
  options = optionlist.split(/,/).map{|o| "--#{o}"}.join(' ')
  run_simple "knife vault refresh #{vault} #{item} -c knife.rb -z #{options}"
end

Given(/^I try to decrypt the vault item '(.+)\/(.+)' as '(.+)'$/) do |vault, item, node|
  run_simple "knife vault show #{vault} #{item} -z -c knife.rb -u #{node} -k #{node}.pem", false
end

Then(/^the vault item '(.+)\/(.+)' should( not)? be encrypted for '(.+)'$/) do |vault, item, neg, nodelist|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data).not_to include(node)
    else
      expect(data).to include(node)
    end
  end
end

Given(/^'(.+)' should( not)? be a client for the vault item '(.+)\/(.+)'$/) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data['clients']).not_to include(node)
    else
      expect(data['clients']).to include(node)
    end
  end
end

Given(/^'(.+)' should( not)? be an admin for the vault item '(.+)\/(.+)'$/) do |nodelist, neg, vault, item|
  nodes = nodelist.split(/,/)
  command = "knife data bag show #{vault} #{item}_keys -z -c knife.rb -F json"
  run_simple(command)
  output = stdout_from(command)
  data = JSON.parse(output)
  nodes.each do |node|
    if neg
      expect(data['admins']).not_to include(node)
    else
      expect(data['admins']).to include(node)
    end
  end
end

Given(/^I list the vaults$/) do
  run_simple('knife vault list')
end

Given(/^I can('t)? decrypt the vault item '(.+)\/(.+)' as '(.+)'$/) do |neg, vault, item, client|
  run_simple "knife vault show #{vault} #{item} -c knife.rb -z -u #{client} -k #{client}.pem", false
  if neg
    assert_not_exit_status(0)
  else
    assert_exit_status(0)
  end
end

Given(/^I add '(.+)' as an admin for the vault item '(.+)\/(.+)'$/) do |newadmin, vault, item|
  run_simple "knife vault update #{vault} #{item} -c knife.rb -z -A #{newadmin}"
end
