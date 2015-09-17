require 'test_helper'

class WorkoutsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should show first 10 workouts by default" do
    get :index
    assert_select 'h3.workout_name', count: 10
    assert_select 'section>h3.workout_name:first-child', /Workout 22/
  end

  test "index should show workouts based on page parameter" do
    get :index, page: 2
    assert_select 'h3.workout_name', count: 10
    get :index, page: 3
    assert_select 'h3.workout_name', count: 2
  end

  test "index response should be valid if workout list is empty" do
    get :index, page: 5000
    assert_response :success 
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "show should include workout info if id param is correct" do
    workout_name = "Upper Body"
    Workout.create(id: 900, name: workout_name, date: 5.days.ago)
    get :show, id: 900
    assert_template :show
    assert_select 'ul.workout_info', /#{workout_name}/, count: 1
  end

  test "show should redirect to root if invalid id" do
    get :show, id: 900
    assert_redirected_to :root 
  end

  test "successful update action should correctly update attributes" do
    w = Workout.create(id: 800, name: "Lower Body", date: 6.days.ago)
    get :show, id: w
    put :update, id: w, workout: { name: "HIIT", date: 4.days.ago}
    assert_equal 'HIIT', Workout.find(800).name
    assert_equal 4.days.ago.to_date, Workout.find(800).date
    assert_template :show, id: 800
  end

  test "unsuccessful update action should render show template" do
    w = Workout.create(id: 800, name: "Lower Body", date: 6.days.ago)
    get :show, id: w
    put :update, id: w, workout: { name: '' }
    assert_equal 'Lower Body', Workout.find(800).name
    assert_template :show, id: 800
  end

  test "saved attributes should display upon unsuccessful update" do
    w = Workout.create(id: 700, name: "Lower Body", date: 4.days.ago)
    workout_name = w.name
    workout_date = w.date
    put :update, id: w, workout: { name: '', date: 'hi' }
    assert_select 'ul.workout_info', /#{workout_date}/, count: 1
    assert_select 'ul.workout_info', /#{workout_name}/, count: 1
  end

  test "proper form error messages should display on failed save" do
    w = Workout.create(id: 700, name: "Lower Body", date: 4.days.ago)
    put :update, id: w, workout: { name: '', note: 'a' * 301 }
    assert_select 'ul.workout_form_errors', /Name can't be blank/
    assert_select 'ul.workout_form_errors', /Note is too long/    
  end
end
