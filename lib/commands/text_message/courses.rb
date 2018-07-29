class Courses
  include CoursesHelper

  TRENDS_IMG = { up: "\xE2\xAC\x86", down: "\xE2\xAC\x87" }
  CURRENCY_IMG = { rub: "\xF0\x9F\x87\xB7\xF0\x9F\x87\xBA",
                   usd: "\xF0\x9F\x87\xBA\xF0\x9F\x87\xB8",
                   eur: "\xF0\x9F\x92\xB6" }

  def self.run(params)
    new(params).perform
  end

  attr_reader :bot, :message

  def initialize(params)
    @bot     = params[:bot]
    @message = params[:message]
  end

  def perform
    text = "#{header}#{courses_lines}"
    bot.api.send_message(chat_id: message.chat.id, text: text)
  end

  private

  def header
    "\xF0\x9F\x92\xB0 Курс валют (#{date}):\n"\
    "                  Покупка:     Продажа:\n"
  end

  def date
    courses_data.first['date'].match(/(\d*-\d*-\d*\s*\d*:\d*)/)
  end

  def currency(line)
    line['currency'].upcase
  end

  def currency_img(line)
    CURRENCY_IMG[line['currency'].to_sym]
  end

  def ask(line)
    value = process_number_value(line['ask'])
    add_space_if_needed(value)
  end

  def bid(line)
    value = process_number_value(line['bid'])
    add_space_if_needed(value)
  end

  def ask_img(line)
    trend_ask = trend_ask(line)
    trend_img(trend_ask)
  end

  def bid_img(line)
    trend_ask = trend_bid(line)
    trend_img(trend_ask)
  end

  def trend_img(value)
    value = value.to_i
    TRENDS_IMG[:up]   if value > 0
    TRENDS_IMG[:down] if value < 0
  end

  def trend_ask(line)
    value = process_number_value(line['trendAsk'])
    make_positive_if_needed(value)
  end

  def trend_bid(line)
    value = process_number_value(line['trendBid'])
    make_positive_if_needed(value)
  end

  def make_positive_if_needed(value)
    return '+' + value if value.to_f > 0

    value
  end

  def add_space_if_needed(value)
    value.match(/\d\d\.\d*/) ? value : ' ' + value
  end

  def courses_lines
    courses_data.reduce('') do |result, line|
      result + "#{currency_img(line)} #{currency(line)}    "\
               "#{ask(line)}(#{trend_ask(line)})#{ask_img(line)}     "\
               "#{bid(line)}(#{trend_bid(line)})#{bid_img(line)}\n"
    end
  end
end
