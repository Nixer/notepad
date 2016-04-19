require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'task.rb'
require_relative 'memo.rb'

puts "Hi, I`m yours notepad! Ver.2.0 + SQLite"
puts "What would you like to put in me?"

choices = Post.post_types.keys

choice = -1

until choice >= 0 && choice < choices.size

  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  choice = STDIN.gets.chomp.to_i
end

entry = Post.create(choices[choice])

entry.read_from_console

id = entry.save_to_db

puts "Your record is saved, id = #{id}"