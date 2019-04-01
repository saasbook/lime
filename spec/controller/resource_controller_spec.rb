require 'rspec'
RSpec.describe ResourcesController, type: :controller do |variable|
	describe "POST create" do
  	it "receive a valid post request via create" do
		#post :create, params: {title: "something", url: "something.com", contact_email: "someting@gmail.com", location: "someplace", types: [type], audiences: [aud], desc: "descriptions"}
		post :create, params: {title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}
		expect(Resource.where(title: "something")).to exist
		resource = Resource.find_by(title: "something")
		# puts resource.audiences
		# puts resource.types
		
		expect(resource.title).to eq "something"
		expect(resource.url).to eq "something.com"
		expect(resource.contact_email).to eq "something@gmail.com"
		expect(resource.location).to eq "someplace"
		expect(resource.audiences).to exist
		expect(resource.types).to exist
		expect(resource.desc).to eq "descriptions"
	  end
	  
	  it "receive an invalid post request via create" do
		post :create, params: {title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}
		post :create, params: {title: "something2",contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}
		expect(Resource.where(title: "something")).to exist
		expect(Resource.where(title: "something2")).not_to exist
	end
  end
end

