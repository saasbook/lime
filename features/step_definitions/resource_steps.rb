Given /the following resources exist:/ do |resources_table|
  resources_table.hashes.each do |resource|
   Resource.create_resource resource
   true
  end
end

Then /the following audiences exist/ do |audiences_table|
  audiences_table.hashes.each do |audience|
    Audience.create audience
  end
end

Then /the following resource_types exist/ do |resource_types_table|
  resource_types_table.hashes.each do |type|
    Type.create type
  end
end

Then /the following locations exist/ do |locations_table|
  global = Location.create :val => "Global"
  global.save :validate => false
  locations_table.hashes.each do |location|
    parent = Location.where(:val => location['parent'].to_s).first
    Location.create! :val => location['location'], :parent => parent
  end
end

Then /I should receive a JSON object/ do
  begin
    json = JSON.parse(@response.body)
    true
  rescue JSON::ParserError => e
    false
  end
end

Then /I should receive all the resources/ do
   json = JSON.parse(@response.body)
   expect(Resource.all.count).to eq json.length
end

Then /the JSON should contain "(.*)"/ do |res|
  json = JSON.parse(@response.body)
  expect(json.any? {|r| r["title"] == res}).to be true
end

Then /the resource should be flagged/ do
  json = JSON.parse(@response.body)
  expect(json["flagged"]).to be 1
end

Then /I should not see resources other than "(.*)"/ do |resource|
  json = JSON.parse(@response.body)
  Resource.all.each do |res|
    if res != resource
      expect(json.include? res).to be false
    end
  end
end

Then /I should not see "(.*)"/ do |resource|
  begin
    json = JSON.parse(@response.body)
    expect(json.include? resource).not_to be true
  rescue JSON::ParserError => e
    expect(@response.include? resource).not_to be true
  end
end

Then /the JSON should be empty/ do
  json = JSON.parse(@response.body)
  expect(json.blank?).to be true
end

When /I make a (GET|POST|PATCH|PUT|DELETE) request to "(.*)" with parameters:$/ do |method, url, params|

  case method
    when "GET"
      @response = page.driver.get(url, params.hashes.first)
    when "POST"
      @response = page.driver.post(url, params.hashes.first)
    when "PATCH"
      @response = page.driver.patch(url, params.hashes.first)
    when "PUT"
      @response = page.driver.put(url, params.hashes.first)
    when "DELETE"
      @response = page.driver.delete(url, params.hashes.first)
    else
      false
  end
end

When /I make a (GET|POST|PATCH|PUT|DELETE) request to "(.*)" with no parameters$/ do |method, url|
  case method
    when "GET"
      @response = page.driver.get(url)
    when "POST"
      @response = page.driver.post(url)
    when "PATCH"
      @response = page.driver.patch(url)
    when "PUT"
      @response = page.driver.put(url)
    when "DELETE"
      @response = page.driver.delete(url)
    else
      false
  end
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit 'resources/new'
end
When /I fill in "(.*)" with "(.*)"/ do |field, value|
  fill_in(field, :with => value)
end

When /I select "(.*)" for "(.*)"/ do |value, field|
  select(value, :from => field)
end

When /I press "(.*)"/ do |button|
  click_button(button)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  json = JSON.parse(@response.body)
  string = JSON.generate(json)
  expect(string.include? text).to be true
end

Then /I should not receive a JSON/ do
  begin
    json = JSON.parse(@response.body)
    false
  rescue JSON::ParserError => e
    true
  end
end

Then /I should see the message "(.*)"/ do |text|
  visit "/resources/new"
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /I should not see the message "(.*)"/ do |text|
  visit "/resources/new"
  if page.respond_to? :should
    page.should_not have_content(text)
  else
    assert !page.has_content?(text)
  end
end
