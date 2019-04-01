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
    JSON.parse(@response.body)
    true
  rescue JSON::ParserError => e
    false
end

Then /I should receive all the resources/ do
   json = ActiveSupport::JSON.decode(@response.body)
   expect(Resource.all.count).eq? json.length
   expect(all("table#resources tr").count).to eq 55
end

Then /the JSON should contain "(.*)"/ do |res|
  json = JSON.parse(@response.body)
  expect(json.any? {|r| r["title"] == res}).to be true
end

Then /I should not see resources other than "(.*)"/ do |resource|
  json = JSON.parse(@response.body)
  Resource.all.each do |res|
    if res != resource
      expect(json.include? res).to be false
    end
  end
end

When /I make a (GET|POST|PATCH|PUT|DELETE) request to "(.*)" with parameters:$/ do |method, url,  params|
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
