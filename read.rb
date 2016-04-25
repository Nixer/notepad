require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'task.rb'
require_relative 'memo.rb'

require 'optparse'

# id, limit, type

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'what type of posts to show (default: any)') { |o| options[:type] = o }
  opt.on('--id POST_ID', 'if id is set - show this post in details') { |o| options[:id] = o }
  opt.on('--limit NUMBER', 'number of the last posts to show (default: all)') { |o| options[:limit] = o }

end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a? Post
  puts "Record #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end

else #show table of results

  print "| id\t | @type\t | @created_at\t\t\t | @text \t\t\t| @url\t\t| @due_date \t"

  result.each do |row|
    puts

    row.each do |element|
      print "| #{element.to_s.delete("\\n\\r")[0..40]}\t"
    end
  end
end

puts