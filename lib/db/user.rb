class User
  include Mongoid::Document

  field :chat_id, type: String
  field :name, type: String
  field :state, type: String, default: 'from_currency'
  field :from_currency, type: String
  field :to_currency, type: String
  field :amount, type: String
  field :converted_value, type: String
end
