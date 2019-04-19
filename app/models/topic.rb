class Topic < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Equality, Human Rights, & Justice', 'Education & Learning',
     'Space', 'Health & Biotech', 'General', 'Social Impact', 'Health',
     'Climate, Environment, & Oceans', 'Science', 'Engineering',
     'Technology', 'Cities', 'International Development', 'Startups+Business',
    ]
  end
end
