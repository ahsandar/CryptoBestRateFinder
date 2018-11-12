
class PriceNode
  attr_accessor :exchange_currency, :graph

  def initialize(exchange_currency)
    @exchange_currency = exchange_currency
  end

  def adjacent_edges
   @graph.edges.select{|e| e.source == self}
 end

 def currency
   @exchange_currency.currency
 end

 def exchange
   @exchange_currency.exchange
 end


 def to_pp
  @exchange_currency.to_pp
 end

end
