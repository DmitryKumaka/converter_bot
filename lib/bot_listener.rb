class BotListener

  def self.listen(params)
    new(params).listen
  end

  attr_reader :bot

  def initialize(bot)
    @bot = bot
  end

  def listen
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::InlineQuery
        InlineQueryProcessor.new(bot: bot, message: message).run
      when Telegram::Bot::Types::Message
        MessageProcessor.run(bot: bot, message: message)
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Щось пішло не так =(")
      end
    end
  end
end
