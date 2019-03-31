require 'rspec'
RSpec.describe ResourcesController, type: :controller do |variable|
	describe "POST create" do
  	it "receive a valid post request via create" do
  		type = Type.create
  		aud = Audience.create
  		#post :create, params: {title: "something", url: "something.com", contact_email: "someting@gmail.com", location: "someplace", types: [type], audiences: [aud], desc: "descriptions"}
  	end
  end
end

