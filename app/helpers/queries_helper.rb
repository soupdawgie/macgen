module QueriesHelper

  def title(obj)
    obj.amount.to_s + " macs, vendor: " + obj.vendor + ", start: " + obj.start
  end

  def format(n, s)
    n = n.to_s(16)
    n[0] = ""
    n.scan(/.{2}/).join(s)
  end
end
