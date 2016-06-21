require 'rspec'
require_relative 'post.rb'

describe 'Post' do
  context "to_db_hash" do
    it 'should return post type and time' do
      post = Post.new
      created_at = Time.now.to_s

      expect(post.to_db_hash).to eq({
                                        'type' => 'Post',
                                        'created_at' => created_at
                                    })
    end
  end
end