module CoursesHelper

  URL = 'http://api.minfin.com.ua/mb/2285b9ba1d8030309ddb1fcf21fb8378118d8d2a'
  CURRENCIES = ['usd', 'eur', 'rub', 'ua']
  MAIN_MENU_BUTTONS = ['Курс валют', 'Конверт валют']
  CONVERTER_TITLES = { from_currency: 'З якої валюти?', to_currency: 'В яку валюту?', amount: 'Введіть суму' }

  def get_data
    Net::HTTP.get(URI(URL))
  end

  def courses_json
    request = get_data
    JSON.parse(request)
  end

  def courses_data
    currencies = CURRENCIES - ['ua']
    currencies.map do |currency|
      courses_json.select {|line| line['currency'] == currency}.first
    end
  end

  def process_number_value(value)
    value.to_f.round(2).to_s
  end

  def reply_keyboard_remove
    Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
  end

  def reply_keyboard_markup(keyboard)
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [keyboard],
                                                  one_time_keyboard: true)
  end

  def update_state(user)
    case user.state
    when 'from_currency'
      user.state = 'to_currency'
    when 'to_currency'
      user.state = 'amount'
    when 'amount'
      user.state = 'calculating'
    when 'calculating'
      user.state = 'from_currency'
    end
    user.save
  end
end
