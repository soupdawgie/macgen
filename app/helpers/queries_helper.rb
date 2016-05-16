module QueriesHelper

  def title(q)
    format('%s macs, vendor: %s, start: %s', q.amount, q.vendor, q.start)
  end

  def mac(ven, pos, sep)
    ven.scan(/.{2}/).join(sep) + sep + pos.to_s(16)[1..-1].scan(/.{2}/).join(sep)
  end
end
