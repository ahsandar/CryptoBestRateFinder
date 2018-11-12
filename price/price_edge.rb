
class PriceEdge

  attr_accessor :source, :destination, :factor

  def initialize(source, destination, factor)
    @source = source
    @destination = destination
    @factor = factor
  end

  def <=>(other)
     self.factor <=> other.factor
   end

   def to_pp
     "(#{source.to_pp}) -- #{factor} --> (#{destination.to_pp})"
   end

end
