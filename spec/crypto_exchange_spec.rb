require_relative 'spec_helper'

describe CryptoExchange do

  context 'Price Input is Invalid' do
    it 'Should raise error for Price Input Invalid' do
      price_input = "2017-11-01T09:42:23+00:00 KRAKEN BTC USD 1000.0"
      expect{Price.new.setup(price_input)}.to raise_error(InValidPriceUpdateFormat)
    end
  end

  context 'Exchange Rate Input is Invalid' do
    it 'Should raise error for Exchange Rate Input Invalid' do
      ex_rate_input = "EXCHANGE_RATE_REQUEST KRAKEN BTC GDAX"
      expect{ExchangeRate.new.setup(ex_rate_input)}.to raise_error(InValidExchageRequestFormat)
    end
  end

  context 'Exchange rate for KRAKEN BTC to GDAX USD' do
    it 'Should have KRAKEN BTC to GDAX USD rate and path' do
      price_obj = setup_price
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST KRAKEN BTC GDAX USD", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql(1001.0)
      expect(best_path).to eql("KRAKEN, BTC\nGDAX, BTC\nGDAX, USD")
    end
  end

  context 'Exchange rate for KRAKEN BTC to KRAKEN USD' do
    it 'Should have KRAKEN BTC to KRAKEN USD rate and path' do
      price_obj = setup_price
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST KRAKEN BTC KRAKEN USD", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql(1001.0)
      expect(best_path).to eql("KRAKEN, BTC\nGDAX, BTC\nGDAX, USD\nKRAKEN, USD")
    end
  end

  context 'Exchange rate for KRAKEN BTC to GDAX BTC' do
    it 'Should have KRAKEN BTC to GDAX BTC rate and path' do
      price_obj = setup_price
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST KRAKEN BTC GDAX BTC", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql(1.0)
      expect(best_path).to eql("KRAKEN, BTC\nGDAX, BTC")
    end
  end

  context 'Exchange rate for GDAX BTC to GDAX USD' do
    it 'Should have GDAX BTC to GDAX USD rate and path' do
      price_obj = setup_price
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST GDAX BTC GDAX USD", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql(1001.0)
      expect(best_path).to eql("GDAX, BTC\nGDAX, USD")
    end
  end

  context 'No Exchange rate  avaialable for GDAX BTC to KRAKEN USD' do
    it 'Should have no rate and path for GDAX BTC to KRAKEN USD' do
      price_obj = Price.new
      price_obj.setup("2017-11-01T09:43:23+00:00 GDAX BTC USD 1001.0 0.0008").update_graph
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST GDAX BTC KRAKEN USD", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql('No Rate Available')
      expect(best_path).to eql(nil)
    end
  end

  context 'No Exchange rate  avaialable for KRAKEN BTC to GDAX USD' do
    it 'Should have no rate and path for KRAKEN BTC to GDAX USD' do
      price_obj = Price.new
      price_obj.setup("2017-11-01T09:43:23+00:00 KRAKEN BTC USD 1000.0 0.0009").update_graph
      exchange_rate = setup_exchage_rate("EXCHANGE_RATE_REQUEST KRAKEN BTC GDAX USD", price_obj)
      best_rate = exchange_rate.best_rate.rate
      best_path = exchange_rate.path
      expect(best_rate).to eql('No Rate Available')
      expect(best_path).to eql(nil)
    end
  end

  def setup_price
    price_obj = nil
    [
      "2017-11-01T09:43:23+00:00 KRAKEN BTC USD 1000.0 0.0009",
      "2017-11-01T09:43:23+00:00 GDAX BTC USD 1001.0 0.0008"
    ].each do |price_input|
      price_obj ||= Price.new
      price_obj.setup(price_input.strip)
      price_obj.update_graph
    end
    price_obj
  end

  def setup_exchage_rate(ex_rate_input, price_obj)
    exchange_rate ||= ExchangeRate.new()
    exchange_rate.setup(ex_rate_input)
    exchange_rate.set_graph(price_obj.graph)
    exchange_rate.trade_rates
    exchange_rate.pp_trades
    exchange_rate
  end

end
