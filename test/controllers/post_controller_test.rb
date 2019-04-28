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
    post.comments.create body: 'wat', user: User.first
    get "/posts/#{post.id}.xlsx", headers: auth_header
    assert_response :ok
    file = Tempfile.new(['foo','.xlsx'])
    file.binmode
    file.write @response.body
    file.write @response.body
    roo = Roo::Excelx.new file.path
    assert_equal ['foobar'], roo.row(2)
    assert_equal ["joachim@nolten.org", "wat"], roo.sheet(1).row(2)
  end

  def auth_header
    token = JsonWebToken.encode(user_id: User.first.id)
    { "Authorization": "Bearer #{token}" }
  end
end
