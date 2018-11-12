

class CryptoExchange

  def self.run
    std_input do |user_input|
       user_input =~ /^EXCHANGE_RATE/ ? get_exchange_rate(user_input) : price_update(user_input)
    end
  end


  def self.std_input(&block)
    loop do
      puts "Input: "
      user_input = gets
      block.call(user_input.strip) if block_given?
      break if user_input.strip =~ /^EXCHANGE_RATE/
    end
  end


  def self.price_update(user_input)
    begin
      @price_obj ||= Price.new
      @price_obj.setup(user_input.strip)
      @price_obj.update_graph
      @price_obj.graph.to_pp_graph
    rescue InValidPriceUpdateFormat => e
      puts e.message
    rescue Exception => e
      puts 'Exception Occured'
      puts e.message
      puts e.backtrace.join("\n")
    end
    @price_obj
  end

  def self.get_exchange_rate(user_input)
    begin
      @exchange_rate ||= ExchangeRate.new()
      @exchange_rate.setup(user_input)
      @exchange_rate.set_graph(@price_obj.graph)
      @exchange_rate.trade_rates
      puts @exchange_rate.pp_trades
    rescue InValidExchageRequestFormat => e
      puts e.message
    rescue Exception => e
      puts 'Exception Occured'
      puts e.message
      puts e.backtrace.join("\n")
    end
    @exchange_rate
  end

end
