require 'csv'

# old way to add CSV file. refer to "upload" in resources_controller.erb
# csv_text = File.read(Rails.root.join('db', 'innovation-resource-database.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')


# WARNING: change the default key when deploying (this code can be public facing)
default_key = Digest::SHA256.hexdigest "adminbear"
Key.create!(:registration_key => default_key)
Location.seed

