# Rapel

Rapel (ruh-PELL) provides a multi-client, multi-runtime REPL server which accepts incoming expressions, e.g. 2+2, evaluates them in a runtime, and returns the result, e.g. 4.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rapel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rapel

## Usage

Place the following in a file named `my_rapel_server.rb`

```ruby

require 'rapel'
Rapel.start

```

Then run the server

```bash
ruby my_rapel_server.rb
```

Place the following in your `.vimrc`

```vim
function! g:get_last_line_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum, col] = getpos("'>")[1:2]
  return lnum
endfunction

function! g:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

ruby << EOF
  require 'json'
  require 'socket'
  begin
    $server = TCPSocket.new('localhost', 8091)
  rescue Errno::ECONNREFUSED
    puts "No Rapel server found"
  end
  def send_exp(exp)
    raise "No Rapel server found" unless $server
    $server.puts({:op => "eval", :code => exp}.to_json)
    JSON.parse($server.gets.chomp)["result"]
  rescue
    $!.inspect
  end

  def send_current_selection
    expression = Vim.evaluate("g:get_visual_selection()")
    send_exp(expression)
  end

  def send_and_print_below
    line_number = Vim.evaluate("g:get_last_line_visual_selection()")
    expression = Vim.evaluate("g:get_visual_selection()")
    result = send_exp(expression)
    Vim::Buffer.current.append(line_number, "\#=> " + result)
  end
EOF

vmap <leader>s :ruby puts send_current_selection<CR>
vmap <leader>S :ruby send_and_print_below<CR>
```

Now open a blank file in vim, and place the following on its own line

```
2+2
```

Then press Shift+V to select the line, then press leader (default backslash) Shift-S, and voila!

```
2+2
#=> 4
```

The evaluated expression will appear beneath your expression!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/domgetter/rapel.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

