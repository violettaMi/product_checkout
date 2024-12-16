class Discount
  def apply(line_item)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
