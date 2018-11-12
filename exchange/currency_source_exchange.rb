class CurrencySourceExchange
  attr_accessor :exchange, :currency

  def initialize(exchange, currency)
    @exchange = exchange
    @currency = currency
  end

  def to_pp
    "#{@exchange}, #{@currency}"
  end

end
