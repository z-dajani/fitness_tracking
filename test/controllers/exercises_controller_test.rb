require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  def setup
    @workout = valid_workout(save: true)
  end

  test "index action with no specified exercise" do
    2.times { valid_exercise(@workout, save: true) }
    get :index
    assert_template :index
    assert_select 'select'
    assert_select 'option', count: 1
    assert_select '#exercise-info', false
  end 

  test "index action when no exercises exist" do
    get :index
    assert_select 'option', false
  end

  test "index action select options should be case insensitive" do
    valid_exercise(@workout, name: 'run', save: true)
    valid_exercise(@workout, name: 'RUN', save: true)
    get :index
    assert_select 'option', count: 1
  end

  test "index action with a specified exercise" do
    e = valid_exercise(@workout, save: true)
    get :index, name: e.name
    assert_select '#exercise-info', count: 1
  end

  test "index action's info about individual exercises" do
    early_workout = valid_workout(date: '2014-1-1', save: true)
    recent_workout = valid_workout(date: '2015-2-2', save: true)
    e = Exercise.create(workout: early_workout, name: 'dbbp')
    Exercise.create(workout: recent_workout, name: e.name)
    
    get :index, name: e.name
    @data = assigns(:data)
    assert_equal early_workout.date, @data[:first_instance]
    assert_equal recent_workout.date, @data[:last_instance]
    assert_select '#first-instance'
    assert_select '#last-instance'

    assert_select '#number-of-instances'
    assert_equal 2, @data[:number_of_instances]

    assert_select '#lightest-set', false
    assert_select '#heaviest-set', false
  end

  test "index action's info about individual exercises' sets" do
    e1 = valid_exercise(@workout, name: 'dbbp')
    e2 = valid_exercise(@workout, name: e1.name)
    valid_e_set(e1, pounds: 10, reps: nil, save: true)
    valid_e_set(e2, pounds: 200, reps: 2, save: true)

    get :index, name: e1.name
    @data = assigns(:data)
    assert_equal 10, @data[:lightest_set][:pounds]
    assert_equal nil, @data[:lightest_set][:reps]

    assert_equal 200, @data[:heaviest_set][:pounds]
    assert_equal 2, @data[:heaviest_set][:reps]

    assert_select '#lightest-set'
    assert_select '#heaviest-set'

  end

  test "index action with a nonexistent specified exercise" do
    get :index, name: 'aaaaa'
    assert_select '#exercise-info', false
  end

end
