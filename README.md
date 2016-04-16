##Macgen

**Macgen** is a simple generator of consecutive MAC addresses, wrapped inside the Rails application (it's always easier to hit an URL then launch a script inside the bash (actually it's not—it just seemed to me a good possibility for practicing).

Macgen introduces a simple **Query** model, that provides the variables to control a loop inside its **show** view—`amount` of addresses, `vendor` ID, address to `start` with and a `separator`.

The main idea is to iterate over some hex values `amount` times from a certain `start` point, then join predefined `vendor` and current hex `position` with the `separator` between each two chars.

There is no need to change vendor ID, it's static, we have to iterate over the last three octets. Here comes an important value: **16777216**—it's a datum point, **1000000** in hex. We need to add some decimal values to set the start—the following method is pretty self-explanatory thanks to the comments:

```ruby
def set_start(obj)
  # Base is 1000000 in hexadecimal, zeros are basically octets
  base  = 16777216
  # Split input to three octets and convert to decimal
  start = obj.start.scan(/.{2}/).map { |n| n.hex }
  # Set 6th octet by adding to base,
  #     5th by adding and multiplying by 256,
  #     4th by adding and multiplying by 65536.
  # Then this value increments inside the cycle
  start = base + start[2] + (start[1] * 256) + (start[0] * 65536)
end
```

At the same time we're passing some locals to our view:

```ruby
def show
  @query = Query.find(params[:id])
  render template: 'queries/show',
         locals:  { amount:   @query.amount,
                    vendor:   @query.vendor,
                    position: set_start(@query),
                    spr:      @query.separator,
                    }
end
```

Here is our loop:

```ruby
<% amount.times do %>
  <p><%= format(vendor, spr) + format(position, spr) %></p>
  <% position += 1 %>
<% end %>
```

Inside the loop we call the `format` method to get the formatted piece of string, provisionally converting decimal to a hex value (e.g. ab:01:00 for the current position and 01:fc:02: for the vendor (with one more colon on the right; I've used those ex facte useless condition to hide the vendor ID join from the view):

```ruby
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
```

That's it! I've ended up with this solution after spending a couple of hours writing really ugly code—with iterations over every octet that stop after getting to ff (255) and adding a zero if the octet contains only one symbol (like "1" or "a"; because `sprintf` doesn't has an option to add zero to a single hex number).

Current implementation works well!

(Some layout was borrowed from my other project (Rubypaste) to speed up the development.)
