##Macgen

**Macgen** is a simple generator of consecutive MAC addresses wrapped inside a Rails application.

Macgen introduces a simple **Query** model, that provides the variables to control a loop inside the **show** view—`amount` of addresses, `vendor` ID, address to `start` with and a `separator`.

The **show** action gets the query and passes its values to the view as locals:

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

The **set_start** method:

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

The loop:

```ruby
<% amount.times do %>
  <p><%= format(vendor, spr) + format(position, spr) %></p>
  <% position += 1 %>
<% end %>
```

The **format** method (the condition is used to hide vendor ID join from the view):

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

(The layout was borrowed from [Rubypaste](https://github.com/soupdawgie/rubypaste) to speed up the development.)
