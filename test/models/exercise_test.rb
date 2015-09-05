require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @exercise = Exercise.new(name: "bench press", sets: 3, repetitions: 10, 
                             seconds: 60.2, note: "PR", workout_id: 1)
    w = Workout.create(id: 1, name: "sprints", date: "2012-3-20")
  end

  test "should be valid" do
    assert @exercise.valid?
  end

  test "name should not be too long" do
    @exercise.name = 'a' * 41
    assert_not @exercise.valid?
  end

  test "name should not be empty" do
    @exercise.name = ''
    assert_not @exercise.valid?
  end

  test "upon saving, name should be downcase" do
    @exercise.name = "LUNGES"
    @exercise.save
    assert @exercise.name = "lunges"
  end

  test "number of sets should not be too large" do
    @exercise.sets = 1000
    assert_not @exercise.valid?
  end

  test "number of sets should be positive" do
    @exercise.sets = -1
    assert_not @exercise.valid?
  end

  test "number of repetitions should not be too large" do
    @exercise.repetitions = 1000
    assert_not @exercise.valid?
  end

  test "number of repetitions should be positive" do
    @exercise.repetitions = -1
    assert_not @exercise.valid?
  end

  test "seconds should not be too large" do
    @exercise.seconds = 100000
    assert_not @exercise.valid?
  end

  test "seconds should be positive" do
    @exercise.seconds = -1
    assert_not @exercise.valid?
  end

  test "note should not be too long" do
    @exercise.note = 'a' * 100
    assert_not @exercise.valid?
  end

  test "sets, repetitions, seconds, and note should be optional" do
    @exercise = Exercise.new(name: "sprints", workout_id: 1)
    assert @exercise.valid?
  end

  test "workout should exist" do
    @exercise.workout = nil
    assert_not @exercise.valid?
  end

  test "workout should exist in the database" do
    @exercise.workout = Workout.new(name: "lunges", date: "2009-1-3")
    assert_not @exercise.valid?
  end

  test "exercise should be deleted from the db when its workout is" do
    @exercise.save
    @exercise.workout.destroy
    assert_not Exercise.find_by(id: @exercise.id)
  end

end
