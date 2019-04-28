require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'can create a user' do
    post '/users', params: { user: { email: 'joachim+2@nolten.org', password: 'Test!123' } }
    assert_response :created
  end

  test 'it can login' do
    post '/users/login', params: { email: 'joachim@nolten.org', password: 'Test!123' }
    assert_response :ok
    assert_equal 'Login Successful', JSON.parse(@response.body)['message']
  end

  test 'it can make an authenticated request' do
    user = User.first
    token = JsonWebToken.encode(user_id: user.id)
    get '/users/me', headers: { "Authorization": "Bearer #{token}" }
    assert_response :ok
    assert_equal user.email, JSON.parse(@response.body)['email']
  end
end
