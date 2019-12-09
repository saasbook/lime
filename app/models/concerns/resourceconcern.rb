module Resourceconcern
  extend ActiveSupport::Concern
  module ClassMethods
    def get_required_resources
      %w[title url location types audiences description]
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

    # returns all resources that have not been updated in a year
    # and has a valid contact email
    def out_of_date_resources
      out_of_date_resources = Set.new
      Resource.all.each do |resource|
        email = resource.contact_email
        if !email.blank? && Email.valid_email?(email) \
          && resource.not_updated_in_a_year? && resource.approval_status == 1
          out_of_date_resources.add(resource)
        end
      end
      out_of_date_resources
    end

    # returns all resources that have a deadline and is expired
    # and has a valid contact email
    def expired_resources
      expired_resources = Set.new
      Resource.all.each do |resource|
        email = resource.contact_email
        if !email.blank? && Email.valid_email?(email) && resource.expired? \
          && resource.approval_status == 1
          expired_resources.add(resource)
        end
      end
      expired_resources
    end

    # returns all resources that have been sent an initial
    # approval email
    def approved_resources_email_sent
      approved_resources_sent = Set.new
      Resource.all.each do |resource|
        email = resource.contact_email
        if !email.blank? && Email.valid_email?(email) \
          && resource.approval_num != 0 && resource.approval_status == 1
          approved_resources_sent.add(resource)
        end
      end
      approved_resources_sent
    end

    # returns all resources that have been sent a broken url email
    def broken_url_resources_email_sent
      broken_url_sent = Set.new
      Resource.all.each do |resource|
        email = resource.contact_email
        if !email.blank? && Email.valid_email?(email) \
           && resource.broken_num != 0
          broken_url_sent.add(resource)
        end
      end
      broken_url_sent
    end

    # sends the initial approval email and sets up the state necessary
    # for future approval emails
    def approval_email(resource)
      UserMailer.with(resource: resource).approval_initial.deliver_now
      email = resource.contact_email
      return unless !email.blank? && Email.valid_email?(email)

      resource.update_column_no_timestamp(:approval_num, 1)
      resource.update_column_no_timestamp(:approval_last, Time.now)
    end

    # sends the initial broken url email and sets up the state necessary
    # for future broken url emails
    def broken_url_email(resource)
      UserMailer.with(resource: resource).broken_url_initial.deliver_now
      email = resource.contact_email
      return unless !email.blank? && Email.valid_email?(email)

      resource.update_column_no_timestamp(:broken_num, 1)
      resource.update_column_no_timestamp(:broken_last, Time.now)
    end
  end
end