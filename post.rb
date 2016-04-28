require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.db'

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link}
  end

  def self.create(type)
    return post_types[type].new
  end

  def self.find_by_id(id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    if id
      db.results_as_hash = true
      begin
      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
      rescue SQLite3::SQLException => e
        puts "Unable to make request in DB #{@@SQLITE_DB_FILE}"
        abort e.message
      end

      result = result[0] if result.is_a? Array

      db.close

      if result.empty?
        puts "This id #{id} is not found in DB! =("
        return nil
      else
        post = create(result["type"])

        post.load_data(result)
        return post
      end
    else
      puts "Unable to find post without id"
      return nil
    end
  end

  def self.find_all(limit, type)

    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

      db.results_as_hash = false

      query = "SELECT rowid, * FROM posts "

      query += "WHERE type = :type " unless type.nil?
      query += "ORDER by rowid DESC "

      query += "LIMIT :limit " unless limit.nil?

    begin
      statement = db.prepare(query)
    rescue SQLite3::SQLException => e
      puts "Unable to make request in DB #{@@SQLITE_DB_FILE}"
      abort e.message
    end

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close
      db.close

      return result
  end



  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_console
    #todo
  end

  def to_strings
    #todo
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    for item in to_strings do
      file.puts (item)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end

  begin
    def save_to_db
      db = SQLite3::Database.open(@@SQLITE_DB_FILE)
      db.results_as_hash = true
      db.execute(
          "INSERT INTO posts (" +
              to_db_hash.keys.join(', ') + ") " +
              " VALUES ( " +
              ('?,'*to_db_hash.keys.size).chomp(',') +
              ")",
          to_db_hash.values
      )
      insert_row_id = db.last_insert_row_id

      db.close

      return insert_row_id
    end

    rescue SQLite3::SQLException => e
      puts "Unable to make a DB request to #{@@SQLITE_DB_FILE}"
      abort e.message
  end

  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

end