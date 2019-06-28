require 'csv'

csv_text = File.read(Rails.root.join('db', 'innovation-resource-database.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
count = 0
csv.each do |row|
  record = {
    'title': row['Resource'],
    'url': row['Resource URL'],
    'resource_email': row['Email-General'],
    'resource_phone': row['Phone-General'],
    'address': row['Address'],
    'contact_email': row['Email-Contact'],
    'contact_name': row['Contact'],
    'contact_phone': row['Phone-Contact'],
    'description': row['Resource Description'],
    'types': row['Resource Type'],
    'audiences': row['Audience'],
    'population_focuses': row['Population Focus'], 
    'location': row['Location'],
    'campuses': row['Campuses'], 
    'colleges': row['College eligibility'], 
    'availabilities': row['Availability'], 
    'deadline': row['Deadline'], 
    'innovation_stages': row['Innovation Type'], 
    'funding_amount': row['Funding Amount'],
    'topics': row['Topic'],
    'technologies': row['Technology'],
    'client_tags': row['Client Tags'],
    'notes': row['Notes'], 
    'approval_status': 1, 
    'approved_by': row['Approved by'],
    'updated_at': '', 
    'flagged': '', 
    'flagged_comment': ''
  }

  if record[:approved_by].nil?
    record[:approved_by] = "Airtable"
  end
  r = Resource.create_resource(record)
  count = count + 1
  # if data is seeded from Airtable, forcefully gets added to database
  # this is because a majority of the seeded database has empty fields
  r.save(validate: false)
end

puts "There are now #{count} rows in the Resource table"

# WARNING: change the default key when deploying (this code can be public facing)
default_key = Digest::SHA256.hexdigest "adminbear"
Key.create!(:registration_key => default_key)
Location.seed

