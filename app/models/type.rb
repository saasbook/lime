class Type < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Events', 'Mentoring', 'Education & Awareness', 'Funding & Grants', 'Networks',
     'Student Groups', 'Fellowships & Scholarships', 'Competitions', 'Investors for Equity, VCs',
     'Accelerators & Incubators', 'Competitions', 'Courses', 'Training & Support', 'Crowdfunding',
     'Job & Internship'
    ]
  end
end
