module QueriesHelper

  def title(q)
    format('%s macs, vendor: %s, start: %s', q.amount, q.vendor, q.start)
  end

  def decorate(vendor, position)
    # vendor ID + separator + loop position converted to a hexadecimal without
    # unnecessary first digit
    separate(vendor) + @query.separator + separate(position.to_s(16)[1..-1])
  end

  def separate(string)
    # inserts a separator between each pair of chars
    string.scan(/.{2}/).join(@query.separator)
  end
end
