require 'twitter'

class Tweet < Post

  @@CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = 'Fl3e3Sn1GohbkLGFaXkCUHOo0'
    config.consumer_secret = '86Asu0TAk6VeS0pIyHFfVgHuZakvySg4jvOvya7gZQL1RGePqi'
    config.access_token = '270043225-dURpekukvXSCNwpw6S22S8vnFUkjbiAjHyJBsHWT'
    config.access_token_secret = 'hctP9fLpQ8E7mkCjo4HRBiGThg4V1W4xXdFOnfxuSKAEt'
  end

  def read_from_console
    puts "New tweet (140 symbols only):"
    @text = STDIN.gets.chomp[0..140]
    puts "Sending your tweet: #{@text.encode('utf-8')}"
    @@CLIENT.update(@text.encode('utf-8'))
  end

  def to_strings
    time_string = "Created: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [time_string, @text]
  end

  def to_db_hash
    return super.merge(
        {
            'text' => @text
        }
    )
  end

  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text']
  end

end