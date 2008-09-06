module Kernel
  protected
  def it() It.new end
  alias its it
  
  def maybe(&block)
    MethodphitamineMaybe.new
  end
end