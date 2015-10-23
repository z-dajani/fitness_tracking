ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in a-z order
  fixtures :all

  def valid_workout(save: false)
    w = Workout.new(name: 'valid note', date: '2015-1-1')
    w.save if save
    w
  end

  def valid_exercise(workout, save: false)
    e = Exercise.new(name: 'valid name', note: 'valid note', 
                     workout: workout)
    e.save if save
    e
  end

  def valid_e_set(exercise, save: false)
    es = ESet.new(pounds: 500.5, reps: 1, exercise: exercise)
    es.save if save
    es
  end
end
