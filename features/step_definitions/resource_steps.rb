Given /the following resouces exist/ do |resouces_table|
  resouces_table.hashes.each do |resouce|
    Resource.create resouce
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

