class Currencies
  include CoursesHelper

  def self.run(params)
    new(params).perform
  end

  attr_reader :bot, :message, :chat_id, :user, :message_text

  def initialize(params)
    @bot               = params[:bot]
    @message           = params[:message]
    @chat_id           = @message.chat.id
    @message_text      = @message.text
    @user              = User.where(chat_id: @chat_id).first
  end

  def perform
    gather_input_data
    bot.api.send_message(chat_id: chat_id, text: CONVERTER_TITLES[user.state.to_sym],
                         reply_markup: markup)
    update_state(user)
  end

  private

  def markup
    if user.state == 'amount'
      reply_keyboard_remove
    else
      reply_keyboard_markup(CURRENCIES - [user.from_currency])
    end
  end

  def gather_input_data
    case user.state
    when 'to_currency'
      user.from_currency = message_text
    when 'amount'
      user.to_currency = message_text
    when 'calculating'
      user.amount = message_text
    end
  end
end
