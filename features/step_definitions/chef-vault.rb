require 'json'

Given(/^I create a vault item '(.+)\/(.+)' containing the JSON '(.+)' encrypted for '(.+)'$/) do |vault, item, json, nodelist|
  write_file 'item.json', json
  query = nodelist.split(/,/).map{|e| "name:#{e}"}.join(' OR ')
  run_simple "knife vault create #{vault} #{item} -z -c knife.rb -A admin -S '#{query}' -J item.json"
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

Given(/^I try to decrypt the vault item '(.+)\/(.+)' as '(.+)'$/) do |vault, item, node|
  run_simple "knife vault show #{vault} #{item} -z -c knife.rb -u #{node} -k #{node}.pem", false
end

Then(/^the vault item '(.+)\/(.+)' should( not)? be encrypted for '(.+)'$/) do |vault, item, neg, nodelist|
  nodes = nodelist.split(/,/)
  run_simple("knife vault show #{vault} #{item} -z -c knife.rb -p clients -F json")
  output = output_from("knife vault show #{vault} #{item} -z -c knife.rb -p clients -F json")
  nodes.each do |node|
    if neg
      assert_no_partial_output(node, output)
    else
      assert_partial_output(node, output)
    end
  end
end
