require 'test_helper'

class FeedbackSubmissionsControllerTest < ActionController::TestCase
  setup do
    @feedback_submission = feedback_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_submission" do
    assert_difference('FeedbackSubmission.count') do
      post :create, feedback_submission: {  }
    end

    assert_redirected_to feedback_submission_path(assigns(:feedback_submission))
  end

  test "should show feedback_submission" do
    get :show, id: @feedback_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback_submission
    assert_response :success
  end

  test "should update feedback_submission" do
    patch :update, id: @feedback_submission, feedback_submission: {  }
    assert_redirected_to feedback_submission_path(assigns(:feedback_submission))
  end

  test "should destroy feedback_submission" do
    assert_difference('FeedbackSubmission.count', -1) do
      delete :destroy, id: @feedback_submission
    end

    assert_redirected_to feedback_submissions_path
  end
end
