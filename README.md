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

To connect, you'll need a client.  Here's one for vim called [vim-rapel-client](github.com/domgetter/vim-rapel-client).
Once you've installed the plugin, place the following in your `.vimrc`

```vim
vmap <leader>s :ruby puts RapelClient.send_current_selection<CR>
vmap <leader>S :ruby RapelClient.send_and_print_below<CR>
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

