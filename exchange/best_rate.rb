class BestRate

  attr_accessor :source, :destination, :rate

  def initialize(source, destination, rate)
    @source = source
    @destination = destination
    @rate = rate
    @path = nil
  end


  def set_path(path)
    @path = path || 'No path'
  end


  def best_path
    @path
  end

  def to_pp
    output = []
    output << "BEST_RATES_BEGIN"
    output << "#{@source.exchange} #{@source.currency} #{@destination.exchange} #{@destination.currency} #{@rate}"
    output << best_path
    output << "BEST_RATES_END"
    output.compact.join("\n")
  end
end
