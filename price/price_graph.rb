class PriceGraph

  attr_accessor :price_nodes, :price_edges

  def initialize
    @price_nodes = []
    @price_edges = []
  end

  def add_price_nodes(nodes)
    nodes = (nodes.is_a? Array) ? nodes : [nodes]
    @price_nodes << nodes
    @price_nodes.flatten!
    nodes.each { |node| node.graph = self }
  end

  def add_price_edges(edge_info)
    edge_info.each do |edge|
      @price_edges << PriceEdge.new(edge[0], edge[1], edge[2])
    end
  end

  def find_other_exchange_currency_node(exchange, currency)
    @price_nodes.collect do |price_node|
         price_node if price_node.exchange != exchange && price_node.currency == currency
  end.compact
end

  def to_pp_graph
    @price_edges.each do |price_edge|
      puts price_edge.to_pp
    end
  end

end
