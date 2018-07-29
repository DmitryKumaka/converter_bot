class InlineQueryProcessor

  def initialize(params)
    @bot     = params[:bot]
    @message = params[:message]
  end

  def run
    results = Telegram::Bot::Types::InlineQueryResultCachedSticker.new(
      id: '1',
      sticker_file_id: 'CAADAgADKQADuhxDEmoglbP4lQ0pAg',
      type: 'sticker'
    )
    @bot.api.answer_inline_query(inline_query_id: @message.id, results: [results])
  end
end
