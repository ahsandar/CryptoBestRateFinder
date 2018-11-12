

class Price

  attr_accessor :timestamp, :exchange, :currency_exchange_source, :currency_exchange_destination,
  :forward_factor, :backward_factor, :graph

    EXCHANGE_CONNECTION_FACTOR = 1.0
    PRICE_REQEUST_LENGTH = 6

    def initialize()
      setup_graph
    end

    def setup(price_line)
      extract_price_structure(price_line)
      self
    end

    def update_graph
      forward_node = PriceNode.new(@currency_exchange_source)
      backward_node = PriceNode.new(@currency_exchange_destination)
      insert_exchange_to_currency_factor(forward_node, backward_node)
      insert_exchange_to_exchange_factor(forward_node, backward_node)
    end

  private

    def setup_graph
      @graph ||= PriceGraph.new
    end

    def extract_price_structure(price_line)
      price_fileds = validate_format(price_line)
      @timestamp = price_fileds[0]
      @currency_exchange_source = CurrencySourceExchange.new(price_fileds[1], price_fileds[2])
      @currency_exchange_destination = CurrencyDestinationExchange.new(price_fileds[1], price_fileds[3])
      @forward_factor = price_fileds[4].to_f
      @backward_factor = price_fileds[5].to_f
    end

    def currency_exchange_source
      @currency_exchange_source
    end

    def currency_exchange_destination
      @currency_exchange_destination
    end

    def source_exchange
      @currency_exchange_source.exchange
    end

    def destination_exchange
      @currency_exchange_destination.exchange
    end

    def source_currency
      @currency_exchange_source.currency
    end

    def destination_currency
      @currency_exchange_destination.currency
    end

   def validate_format(price_line)
     price_fields = price_line.split(" ")
     raise InValidPriceUpdateFormat if price_fields.size != PRICE_REQEUST_LENGTH
     price_fields
   end

   def insert_exchange_to_currency_factor(forward_node, backward_node)
     @graph.add_price_nodes([forward_node, backward_node])
     @graph.add_price_edges(
       [
       [forward_node,backward_node, @forward_factor],
       [backward_node,forward_node, @backward_factor]
     ]
   )
   end

   def insert_exchange_to_exchange_factor(forward_node, backward_node)
     insert_exchange_forward_factor(forward_node)
     insert_exchange_backward_factor(backward_node)
   end

   def insert_exchange_forward_factor(forward_node)
     other_exchange_forward_nodes = @graph.find_other_exchange_currency_node(source_exchange, source_currency)
     other_exchange_forward_nodes.each do |graph_node|
       @graph.add_price_edges(
         [
           [forward_node,graph_node, EXCHANGE_CONNECTION_FACTOR],
           [graph_node,forward_node, EXCHANGE_CONNECTION_FACTOR]
         ]
        )
     end
   end

   def insert_exchange_backward_factor(backward_node)
     other_exchange_backward_nodes = @graph.find_other_exchange_currency_node(destination_exchange, destination_currency)
     other_exchange_backward_nodes.each do |graph_node|
       @graph.add_price_edges(
         [
           [backward_node,graph_node, EXCHANGE_CONNECTION_FACTOR],
           [graph_node,backward_node, EXCHANGE_CONNECTION_FACTOR]
         ]
       )
     end
   end

end
