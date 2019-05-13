Given /the following resources exist:/ do |resources_table|
  resources_table.hashes.each do |resource|
   Resource.create_resource resource
   true
  end
end

Given /the following users exist:/ do |users_table|
  users_table.hashes.each do |user|
    User.create user
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
    success = true
  rescue JSON::ParserError => e
    success = false
  end
  expect(success).to be true
end

Then /the JSON should contain all the resources/ do
   json = JSON.parse(@response.body)
   expect(Resource.all.count).to eq json.length
end

Then /I should receive one edit/ do
  expect(Edit.all.count).to eq 1
end

Then /the JSON should contain "(.*)"/ do |res|
  json = JSON.parse(@response.body)
  if json.is_a? Array
    expect(json.any? {|r| r["title"] == res}).to be true
  else
    expect(json["title"] == res).to be true
  end
end

Then /the resource should have the attribute "(.*)" equal to "(.*)"/ do |attribute, value|
  json = JSON.parse(@response.body)
  expect(json[attribute.to_s].to_s).to match value.to_s
end

Then /the first resource should have the attribute "(.*)" equal to "(.*)"/ do |attribute, value|
  json = JSON.parse(@response.body)[0]
  expect(json[attribute.to_s].to_s).to match value.to_s
end

Then /the JSON should not contain resources other than "(.*)"/ do |resource|
  json = JSON.parse(@response.body)
  Resource.all.each do |res|
    if res != resource
      expect(json.include? res).to be false
    end
  end
end

Then /the JSON should not contain "(.*)"/ do |resource|
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

# Then /the following users exist/ do |users_table|
#   users_table.hashes.each do |user|
#     # User.create!(user)
#     User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
#   end
# end

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

Given /^(?:|I )am on "(.+)"$/ do |page_name|
  visit page_name
end

When /I (?:try to )visit "(.*)"$/ do |page_name|
  visit page_name
end

When /I fill in "(.*)" with "(.*)"/ do |field, value|
  fill_in(field, :with => value)
end

When /I select "(.*)" for "(.*)"/ do |value, field|
  check(:id => value)
end

When /I press "(.*)"/ do |button|
  click_button(button)
end

When /I follow "(.*)"/ do |link|
  click_link link
end

When /I choose "(.*)" for "(.*)"/ do |value, field|
  choose(:id => value)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  json = JSON.parse(@response.body)
  string = JSON.generate(json)
  expect(string.include? text).to be true
end

Then /I should not receive a JSON/ do
  begin
    json = JSON.parse(@response.body)
    success = false
  rescue JSON::ParserError => e
    success = true
  end
  expect(success).to be true
end

Then /I should see the message "(.*)"/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /I should see the text "(.*)"/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /I should not see the message "(.*)"/ do |text|
  if page.respond_to? :should
    page.should_not have_content(text)
  else
    assert !page.has_content?(text)
  end
end

Then /the "(.*)" resource should be unapproved/ do |resource|
  resource = Resource.find_by(:title => resource)
  expect(resource.approval_status).to eq 0
end

Then /the "(.*)" resource should be approved/ do |resource|
  expect(Resource.where(:title => resource).first.approval_status).to eq 1
end

Then /all the resources should be approved/ do
  expect(Resource.all.any? {|r| r.approval_status == 0}).to be false
end

When /I approve the following resources with api key "(.*)":/ do |api_key, params|
  resources = params.hashes.map {|r| Resource.where(:title => r["title"]).first.id.to_s}
  if resources.length > 1
    # ids = resources * ","
    @response = page.driver.put('/resources/approve/many', {:approve_list => resources, :api_key => api_key, :approval_status => 1})
  else
    @response = page.driver.put("/resources/approve/#{resources[0]}", {:api_key => api_key, :approval_status => 1})
  end
end

Then /the response status should be "(.*)"/ do |code|
  expect(@response.status).to eq code.to_i
end

When /I approve resources "(.*)" with api key "(.*)"/ do |ids, api_key|
  resources = ids.split(',')
  @response = page.driver.put('/resources/approve/many', {:approve_list => resources, :api_key => api_key})
end

Then /I should not see the "(.*)" button inside the "(.*)" (.*)/ do |button_name, class_name, element|
  page.first("#{element}.#{class_name}").should_not have_content button_name  
end

Then /I should be redirected to the page titled "(.*)"/ do |page_title|
  expect(page.first("h1").text).to eq page_title
end

Given /I am logged in with user "(.*)" and password "(.*)"/ do |user, pass|
  visit "/users/sign_in"
  fill_in("Email", :with => user)
  fill_in("Password", :with => pass)
  click_button("Log in")
end

Then /I should see all the unapproved resources/ do
  expect(Resource.where(:approval_status => 0).all? {|r| page.should have_content r.title}).to be true
end

Then /I should be on the welcome page/ do
  expect(page.find('#welcome-title').text).to eq "UC Berkeley Innovation Resource Database"
end
