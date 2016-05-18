## Macgen

**Macgen** is a simple generator of consecutive MAC addresses wrapped inside a Rails application.

Macgen introduces a simple **Query** model that provides the variables to control a loop inside the **show** view—`amount` of addresses, `vendor` ID, address to `start` and a `separator`.

The **show** action:

```ruby
# gets the query and passes its values to the view as locals
def show
  @query = Query.find(params[:id])
  locals amount: @query.amount,
         vendor: @query.vendor,
         position: set_start(@query)
end

private

def locals(values)
  render locals: values
end
```

The **set_start** method:

```ruby
def set_start(obj)
  # 1000000 in hexadecimal
  base  = 16777216
  # converts the entered octets to decimals
  start = obj.start.scan(/.{2}/).map { |n| n.hex }
  # sets a starting point for the loop
  base + start[2] + (start[1] * 256) + (start[0] * 65536)
end
```

The loop:

```ruby
# renders the addresses
<% amount.times do %>
  <p><%= decorate(vendor, position) %></p>
  <% position += 1 %>
<% end %>
```

The **format** method:

```ruby
def decorate(vendor, position)
  # vendor ID + separator + loop position converted to a hexadecimal without
  # unnecessary first digit
  separate(vendor) + @query.separator + separate(position.to_s(16)[1..-1])
end

def separate(string)
  # inserts a separator between each pair of chars
  string.scan(/.{2}/).join(@query.separator)
end
```
