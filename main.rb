require 'telegram/bot'
require 'net/http'
require 'json'
require 'date'
require 'mongoid'

Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib','commands', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib','commands', 'inline', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib','commands', 'text_message', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib','db', '*.rb')].each { |file| require file }

Mongoid.load!(File.join(File.dirname(__FILE__), 'lib/db/mongoid.yml'), :development)

class ConvertUa
  TOKEN = '632755127:AAEdR5Jt4tRVXgRH0PtiycFPMhF0mE542SY'

  Telegram::Bot::Client.run(TOKEN) do |bot|
    BotListener.listen(bot)
  end
end
