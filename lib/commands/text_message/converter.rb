class Converter
  include CoursesHelper

  def self.run(params)
    new(params).perform
  end

  attr_reader :bot, :message, :chat_id, :user

  def initialize(params)
    @bot        = params[:bot]
    @message    = params[:message]
    @chat_id    = @message.chat.id
    @user       = User.where(chat_id: @chat_id).first
  end

  def perform
    title = CONVERTER_TITLES[user.state.to_sym]
    bot.api.send_message(chat_id: chat_id, text: title,
                         reply_markup: reply_keyboard_markup(CURRENCIES))
    update_state(user)
  end
end
