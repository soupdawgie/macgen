module QueriesHelper

  def title(query)
    # Get a humanized title like "200 macs, vendor: aabbcc, start: ff00aa"
    query.amount.to_s + " macs, vendor: " +
    query.vendor      + ", start: " +
    query.start
  end

  def format(obj, spr)
    # If format gets Fixnum, it's the current position of our iteration —
    # method converts it to a hex string, throws away the first digit of
    # the base and inserts some separators. Else it's a vendor ID — method
    # inserts separators again and adds one more between the ID and address.
    if obj.class == Fixnum
      obj = obj.to_s(16)
      obj[0] = ""
      obj.scan(/.{2}/).join(spr)
    else
      obj.scan(/.{2}/).join(spr) + spr
    end
  end

end
