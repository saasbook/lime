class Resource < ActiveRecord::Base
  has_many :types
  has_many :audiences
  has_many :client_tags
  has_many :population_focuses
  has_many :campuses
  has_many :colleges
  has_many :availabilities
  has_many :innovation_stages
  has_many :topics
  has_many :technologies
  # validations: https://guides.rubyonrails.org/active_record_validations.html
  validates :title, :url, :contact_email, :location, :types, :audiences, :presence => true
  validates :desc, :presence => true, :length => {:maximum => 500}
end
