class ExchangeRate

  EXCHANGE_RATE_REQUEST_LENGTH = 5
  attr_accessor :graph, :source, :destination, :best_rate, :path

  def initialize()
    @rates = {}
    @next = {}
  end

  def setup(exchange_line)
    exchange_fields = exchange_line.split(" ")
    raise InValidExchageRequestFormat if exchange_fields.size != EXCHANGE_RATE_REQUEST_LENGTH
    set_source(exchange_fields[1], exchange_fields[2])
    set_destination(exchange_fields[3], exchange_fields[4])
  end

  def set_graph(graph)
    @graph = graph
    setup_rate_and_next
    matrix
  end

  def trade_rates
    graph.price_nodes.each do |k|
      graph.price_nodes.each do |i|
        graph.price_nodes.each do |j|
          i_node = i.to_pp
          j_node = j.to_pp
          k_node = k.to_pp
          if @rates[i_node][j_node].to_f < @rates[i_node][k_node].to_f * @rates[k_node][j_node].to_f
            @rates[i_node][j_node] = @rates[i_node][k_node].to_f * @rates[k_node][j_node].to_f
            @next[i_node][j_node] = @next[i_node][k_node]
          end

        end
      end
    end
  end

  def pp_trades
    @best_rate = BestRate.new(@source, @destination, get_rate)
    @best_rate.set_path(extract_path)
    @best_rate.to_pp
  end

private

  def set_source(exchange, currency)
    @source = CurrencySourceExchange.new(exchange, currency)
  end

  def set_destination(exchange, currency)
    @destination = CurrencyDestinationExchange.new(exchange, currency)
  end




  def matrix
    graph.price_edges.each do |price_edge|
      @rates[price_edge.source.to_pp][price_edge.destination.to_pp] = price_edge.factor
      @next[price_edge.source.to_pp][price_edge.destination.to_pp] = price_edge.destination.to_pp
    end
  end

  def setup_rate_and_next
    graph.price_nodes.each do |price_node_u|
      @rates[price_node_u.to_pp] ||= {}
      @next[price_node_u.to_pp] ||= {}
      graph.price_nodes.each do |price_node_v|
        @rates[price_node_u.to_pp][price_node_v.to_pp] = 0
        @next[price_node_u.to_pp][price_node_v.to_pp] = nil
      end
    end
  end


  def get_rate
    (@rates[@source.to_pp] && @rates[@source.to_pp][@destination.to_pp]) || 'No Rate Available'
  end

  def extract_path
    return [] if @next[@source.to_pp] && @next[@source.to_pp][@destination.to_pp].nil?
    @path = []
    graph.price_nodes.each do |i|
      graph.price_nodes.each do |j|
        i_node = i.to_pp
        j_node = j.to_pp
        next  if i_node == j_node
        u_node = i_node
        @path = [u_node]
        while u_node != j_node do
          break if u_node.nil? || j_node.nil?
          return [] if @next[u_node][j_node].nil?
          @path << (u_node = @next[u_node][j_node])
        end
        @path = @path.map{|u| u}.join("\n")
        return "#{@path}" if i_node == @source.to_pp && j_node == @destination.to_pp
      end
    end
     []
  end


end
