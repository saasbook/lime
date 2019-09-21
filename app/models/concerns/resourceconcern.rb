module Resourceconcern
    extend ActiveSupport::Concern
    module ClassMethods
        def get_required_resources
            return ["title", "url", "location", "types", "audiences", "description"]
        end

        def all_values_hash
        {
            "Contact Email" => "contact_email",
            "Contact Name" => "contact_name",
            "Contact Phone" => "contact_phone",
            "URL" => "url",
            "Description" => "description",
            "Location" => "location",
            "Resource Email" => "resource_email",
            "Resource Phone" => "resource_phone",
            "Address" => "address",
            "Funding Amount" => "funding_amount",
            "Deadline" => "deadline",
            "Notes" => "notes",
            'Types' => "types",
            'Audiences' => "audiences",
            'Campuses' => "campuses",
            'Innovation Stages' => "innovation_stages",
            'Population Focuses' => "population_focuses",
            'Availabilities' => "availabilities",
            'Topics' => "topics",
            'Technologies' => "technologies",
            'Client tags' => "client_tags",
            "Approval Status" => "approval_status",
            "Approved By" => "approved_by",
            "Flagged" => "flagged",
            "Flagged Comment" => "flagged_comment",
            "Created on" => "created_at",
            "Updated on" => "updated_at"
        }
        end

        def all_public_values_hash
        {
            "URL" => "url",
            "Description" => "description",
            "Location" => "location",
            "Resource Email" => "resource_email",
            "Resource Phone" => "resource_phone",
            "Address" => "address",
            "Funding Amount" => "funding_amount",
            "Deadline" => "deadline",
            "Notes" => "notes",
            'Types' => "types",
            'Audiences' => "audiences",
            'Campuses' => "campuses",
            'Innovation Stages' => "innovation_stages",
            'Population Focuses' => "population_focuses",
            'Availabilities' => "availabilities",
            'Topics' => "topics",
            'Technologies' => "technologies",
            'Client tags' => "client_tags",
            "Created on" => "created_at",
            "Updated on" => "updated_at"
        }
        end
    end

end