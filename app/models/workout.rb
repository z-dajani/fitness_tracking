class Workout < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 35 }

 # validates_date :date, allow_nil: false, before: 2.years.from_now,  
 #                                                        after: '1999-12-31'
    validates_date :date, allow_nil: false, between: ['2000-1-1', 2.years.from_now]
 validates :note, allow_nil: true, length: { maximum: 300 }
end
