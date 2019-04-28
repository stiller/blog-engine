require 'test_helper'

class PostControllerTest < ActionDispatch::IntegrationTest
  test 'can create post' do
    post '/posts', params: { post: { body: 'Lorem ipsum' } }, headers: auth_header
    assert_response :created
    assert_equal 'Lorem ipsum', JSON.parse(@response.body)['body']
  end

  test 'can show json of post' do
    post = User.first.posts.create body: 'foobar'
    get "/posts/#{post.id}", headers: auth_header, as: :json
    assert_equal 'foobar', JSON.parse(@response.body)['body']
  end

  test 'can show xlsx of post' do
    post = User.first.posts.create body: 'foobar'
    get "/posts/#{post.id}.xlsx", headers: auth_header
    assert_response :ok
  end

  def auth_header
    token = JsonWebToken.encode(user_id: User.first.id)
    { "Authorization": "Bearer #{token}" }
  end
end
