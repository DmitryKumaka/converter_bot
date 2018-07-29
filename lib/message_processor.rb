class MessageProcessor
  include CoursesHelper

  def self.run(params)
    new(params).run
  end

  attr_reader :bot, :message, :chat_id, :user

  def initialize(params)
    @bot        = params[:bot]
    @message    = params[:message]
    @chat_id    = @message.chat.id
    @user       = User.where(chat_id: @chat_id).first
  end

  def run
    p '=======@message.text========='
    p @message.text

    text = message.text
    if text == '/start'
      Start.run(bot: bot, message: message)
    elsif ['/courses', 'Курс валют'].include?(text)
      Courses.run(bot: bot, message: message)
    elsif ['/converter', 'Конверт валют'].include?(text)
      Converter.run(bot: bot, message: message)
    elsif CURRENCIES.include?(text)
      Currencies.run(bot: bot, message: message)
    elsif user.state == 'calculating'
      Calculator.run(bot: bot, message: message)
    end
  end
end
