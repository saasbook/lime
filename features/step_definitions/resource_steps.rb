Given /the following resources exist/ do |resources_table|
  resources_table.hashes.each do |resource|
    Resource.create resource
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
  locations_table.hashes.each do |location|
    Location.create location
  end
end

# 55 Total resouces
Then /I should receive all the resources/ do
   expect(all("table#resources tr").count).to eq 55
end

And /I should receive (.*)/ do |res|
  #parse_json(resource) => check if json has this res by name
  json = ActiveSupport::JSON.decode(@response.body)
  json['resource']['name'].should == res
end

Then /I should receive (.*)/ do |res|
  json = ActiveSupport::JSON.decode(@response.body)
  json['resource']['name'].should == res
end

When /I make a (GET|POST|PATCH|PUT|DELETE) request to to "(.*?)" with:$/) do |method, url, params| do
  unless param.hashes.empty?
    query = param.hashes.first.map{|key, value| %/#{key}=#{value}/}.join("&")
    url = url.include?('?') ? %/#{url}&#{query}/ : %/#{url}?#{query}/
end

