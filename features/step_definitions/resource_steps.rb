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
    return true
  rescue JSON::ParserError => e
    return false
end

Then /I should receive all the resources/ do
   json = ActiveSupport::JSON.decode(@response.body)
   byebug
   expect(Resource.all.count).eq? json.length
   expect(all("table#resources tr").count).to eq 55
end

Then /I should receive (.*)/ do |res|
  #parse_json(resource) => check if json has this res by name
  json = ActiveSupport::JSON.decode(@response.body)
  json['resource']['name'].should == res
end

When /I make a (GET|POST|PATCH|PUT|DELETE) request to "(.*)" with parameters:$/ do |method, url,  params|
  # #{root_url}
    #query = param.hashes.first.map{|key, value| %/#{key}=#{value}/}.join("&")
    #url = url.include?('?') ? %/#{url}&#{query}/ : %/#{url}?#{query}/
  #end
end

