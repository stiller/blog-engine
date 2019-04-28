require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test 'can create comment referencing a post' do
    post "/posts/#{Post.first.id}/comments",
      params: { comment: { body: 'My comment' }, references: Post.first.id },
      headers: auth_header
    assert_response :created
    assert_equal 'My comment', JSON.parse(@response.body)['body']
    assert_equal 'Post', JSON.parse(@response.body)['commentable_type']
  end

  test 'can create comment referencing another comment' do
    post "/comments/#{Comment.first.id}/comments",
      params: { comment: { body: 'Another' }, references: Comment.first.id },
                      headers: auth_header
    assert_response :created
    assert_equal 'Another', JSON.parse(@response.body)['body']
    assert_equal 'Comment', JSON.parse(@response.body)['commentable_type']
  end

  def auth_header
    token = JsonWebToken.encode(user_id: User.first.id)
    { "Authorization": "Bearer #{token}" }
  end
end
