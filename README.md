# Simple Log Counter for Ruby Developer Test

This is a command line tool for counting both unique and non-unique
visits to individual web pages given a log file.

## Design Thinking

### Building a Unix Tool

I wanted from the outset that this tool behave in accordance with the [Unix
Tools Philosophy](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/c1089.htm),
and receive input either from the Standard Input or a file name passed as a
parameter.

Using exiting command-line tools, the non-unique version of this task for
counting visits to a given web page could be solved like so:

	$ cat webserver.log | grep /home | sort | wc -l
	
I therefore wanted my new solution, which summaries counts for all web pages, to
be used like:

	$ simple_log_counter webserver.log
	
OR

	$ cat webserver.log | simple_log_counter
	
Similarly, whereas the unique version of the task has a conventional solution of:

	$ cat webserver.log | grep /home | sort | uniq | wc -l
	
My new solution would be:

	$ simple_log_counter --unique webserver.log
	
OR

	$ cat webserver.log | simple_log_counter --unique


### RubyGems

I chose to package the application as a Ruby Gem, so I could leverage the support of
its best-practice tooling, in particular the support for platform-independent
installs. Please note, however, that the gem not has been added to
[RubyGems](https://rubygems.org), so will have to be installed locally ([see
below](#installation) for installation instructions).

### TDD

The task was solved in the spirit of test driven development. Following some initial
exploration in the console, the process of development went spec first, then code.

Only the linking code that makes up the [script file](exe/simple_log_counter) is
not covered by a spec. This was considered acceptable as the linking code
follows a standard Ruby idiom. Specs will need to be added if the CLI becomes
more advanced with the addition of, say, a help option or additional controls.

### Separation of concerns

The responsibility for parsing a text stream into a hash of page counts is in
[SimpleLogCounter::Parser](lib/simple_log_counter/parser.rb). The responsibility
for printing to screen is in
[SimpleLogCounter::Formatter](lib/simple_log_counter/formatter.rb). All methods
were implemented as class methods as the initial domain modelling did not
suggest the need for management of additional state.

### Extension

The original problem only required that records of the log file follow a
simple, 2-field format, comprising page and visitor IP address. This is
fine for a toy example, but real log files are more complex. Examples of real log files 
include those for IIS (Internet Information Service):
```
02:49:12 127.0.0.1 GET / 200
02:49:35 127.0.0.1 GET /index.html 200
03:01:06 127.0.0.1 GET /images/sponsered.gif 304
```

And Apache:

```
192.168.198.92 - - [22/Dec/2002:23:08:37 -0400] "GET / HTTP/1.1" 200 6394 www.yahoo.com "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1...)" "-"
192.168.198.92 - - [22/Dec/2002:23:08:38 -0400] "GET /images/logo.gif HTTP/1.1" 200 807 www.yahoo.com "http://www.some.com/" "Mozilla/4.0 (compatible; MSIE 6...)" "-"
```

I thought it might be nice if the program could be extended to work with these
more realistic examples.

I made the following assumptions for this additional work:

1. Pages start with `/`
2. IP addresses are in IPv4 dotted-decimal notation

See the [parser_spec.rb](spec/parser_spec.rb) for examples and capability.

## Installation

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. To install this gem onto your local machine, run
`bundle exec rake install`.

## Usage

In addition to the examples above, you might want to work with the included IIS and Apache samples.

	$ simple_log_counter iis_sample.log
	
	$ simple_log_counter apache_sample.log


## Next Steps

- Benchmark performance

- Further testing on different types of log format, such as that of Nginx.

- Use [Thor](https://github.com/rails/thor) to encapsulate application as a
  self-documenting command-line utility.

- Support for Ipv6

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jhoodsmith/simple_log_counter.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
