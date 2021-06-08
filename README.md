# Simple Log Counter for Ruby Developer Test

This is a command line tool for counting both unique and non-unique
visits to individual web pages given a log file.

Each record of the log file is on a new line and each line is composed of two
fields for page visited and IP address of visitor.


## Design Thinking

### Building a Unix Tool

Despite its simplicity and limited scope, I wanted from the outset for this tool
it behave in accordance with the [Unix Tools
Philosophy](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/c1089.htm), and be
simple tool that could receive input from with the Standard Input or a file
name.

Using exiting command-line tools, the non-unique version of this task for
counting visit to a given web page could be solved like so:

	$ cat webserver.log | grep /home | sort | wc -l
	
I therefore wanted my new solution, which summaries counts for all web pages, to
be used either:

	$ simple_log_counter webserver.log
	
or

	$ cat webserver.log | simple_log_counter
	
Similarly, whereas the unique version of the task has a conventional solution of:

	$ cat webserver.log | grep /home | sort | uniq | wc -l
	
My new solution should be used either:

	$ simple_log_counter --unique webserver.log
	
or

	$ cat webserver.log | simple_log_counter --unique


### RubyGems

I chose to package the task as a Ruby Gem, so I could leverage the support
of its best-practice tooling, in particular the support for platform-independent installs

### TDD

The task was solved in the spirit of test driven development. Following some initial
exploration in the console, the process of development went spec first, then code.

Only the linking code that makes up the script file is not covered by a spec.
This was considered acceptable as the linking code follows a standard Ruby
idiom. Specs will need to be added if the CLI becomes more advanced - e.g., help
option, additional controls.

### Separation of concerns

The responsibility for parsing a text stream into a hash of page counts is in
[SimpleLogCounter::Parser](lib/simple_log_counter/parser.rb). The responsibility
for printing to screen is in
[SimpleLogCounter::Parser](lib/simple_log_counter/formatter.rb). All methods
were implemented as class methods as the initial domain modelling did not
suggest the need for management of additional state.

## Installation

The gem has been added to [rubygems.org](https://rubygems.org) so can be
installed in the usual way.

Either add this line to your application's Gemfile:

```ruby
gem 'simple_log_counter'
```

And then execute:

	$ bundle install

Or install it yourself as:

    $ gem install simple_log_counter

## Usage

See examples above.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Next Steps

- Benchmark performance

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jhoodsmith/simple_log_counter.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
