class Calculator
  include CoursesHelper

  def self.run(params)
    new(params).perform
  end

  attr_reader :bot, :message, :chat_id, :user, :message_text

  def initialize(params)
    @bot            = params[:bot]
    @message        = params[:message]
    @chat_id        = @message.chat.id
    @user           = User.where(chat_id: @chat_id).first
    @message_text   = @message.text
  end

  def perform
    return try_one_more_time unless validate_amount?

    user.amount = message_text
    update_state(user)
    bot.api.send_message(chat_id: chat_id, text: calculate_amount, reply_markup: reply_keyboard_remove)
  end

  private

  def calculate_amount
    amount        = user.amount
    from_currency = user.from_currency
    to_currency   = user.to_currency

  end

  def try_one_more_time
    title = 'Сума введена некоректно. Спробуйте ще раз.'
    bot.api.send_message(chat_id: chat_id, text: title, reply_markup: reply_keyboard_remove)
  end

  def validate_amount?
    !!Float(message_text) rescue false
  end
end
