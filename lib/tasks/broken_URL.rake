namespace :broken_URL do
    desc 'Every 2 weeks check + tag Broken URLs'
    task broken_URLs: :environment  do

            @resources = Resource.all #location_helper(resource_params)

            @resources.map do |resource|
              resource.isURLBroken_ifSoTagIt()
            end
    end
end