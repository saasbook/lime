module ResourcesControllerUpload
    def upload
        uploaded_io = params[:csv]
        if uploaded_io == nil
            flash[:alert] = "Please choose a file first before uploading."
            redirect_to "/resources/unapproved.html"
            return
        end
        csv_text = uploaded_io.read
        csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
        count = 0
        csv.each do |row|
            record = {
            'title': row['Title'],
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
            'approval_status': 0, 
            'approved_by': row['Approved by'],
            'updated_at': '', 
            'flagged': '', 
            'flagged_comment': ''
            }

            params, resource_hash = Resource.separate_params(record)
            r = Resource.create_resource(resource_hash)
            r.save(validate: false)
            Resource.create_associations(r, params)
            count = count + 1
            # if data is seeded from CSV file, forcefully gets added to database
            # this is because a majority of the seeded database has empty or invalid fields
            
        end

        flash[:notice] = "Added #{count} resources to the approval queue"
        redirect_to "/resources/unapproved.html"
    end
end