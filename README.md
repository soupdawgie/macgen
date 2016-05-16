## Macgen

**Macgen** is a simple generator of consecutive MAC addresses wrapped inside a Rails application.

Macgen introduces a simple **Query** model that provides the variables to control a loop inside the **show** view—`amount` of addresses, `vendor` ID, address to `start` and a `separator`.

### How it works
The **show** action:

```ruby
# gets the query and passes its values to the view as locals
def show
  @query = Query.find(params[:id])
  render template: 'queries/show',
         locals: { amount: @query.amount,
                   vendor: @query.vendor,
                   position: set_start(@query),
                   sep: @query.separator }
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
  start = base + start[2] + (start[1] * 256) + (start[0] * 65536)
end
```

The loop:

```ruby
# renders the addresses
<% amount.times do %>
  <p><%= format(vendor, sep) + format(position, sep) %></p>
  <% position += 1 %>
<% end %>
```

The **format** method:

```ruby
def format(obj, sep)
  # if it's a vendor ID
  return separate(obj) + sep if obj.class == String
  # if it's a position of the iteration
  separate(obj.to_s(16).slice(0))
end

def separate(str)
  # inserts a separator between each pair of chars
  str.scan(/.{2}/).join(sep)
end
```
