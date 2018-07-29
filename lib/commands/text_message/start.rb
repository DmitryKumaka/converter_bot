class Start
  include CoursesHelper

  def self.run(params)
    new(params).perform
  end

  attr_reader :bot, :message, :chat_id

  def initialize(params)
    @bot        = params[:bot]
    @message    = params[:message]
    @message    = params[:message]
    @chat_id    = @message.chat.id
  end

  def perform
    title = 'Привіт! Вибери дію :)'

    User.where(chat_id: chat_id).size.zero? ? create_user : reset_user
    bot.api.send_message(chat_id: chat_id, text: title,
                         reply_markup: reply_keyboard_markup(MAIN_MENU_BUTTONS))
  end

  private

  def create_user
    User.new(chat_id: chat_id, name: @message.chat.first_name).save
  end

  def reset_user
    user = User.where(chat_id: chat_id).first
    user.write_attributes(
      state: 'from_currency',
      from_currency: nil,
      to_currency: nil,
      amount: nil,
      converted_value: nil)
    user.save
  end
end
