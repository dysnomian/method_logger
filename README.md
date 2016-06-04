# MethodLogger

## The Challenge

*Your challenge, should you accept it, is to write a Ruby library that will modify an existing program to output the number of times a specific method is called.*

You solution library should be required at the top of the host program, or via ruby's -r flag (i.e. `ruby -r ./solution.rb host_program.rb`).

Your solution library should read the environment variable `COUNT_CALLS_TO` to determine the method it should count. Valid method signatures are `Array#map!`, `ActiveRecord::Base#find`, `Base64.encode64`, etc.

Your solution library should count calls to that method, and print the method signature and the number of times it was called when the program exits.

Also, your solution should have a minimal impact on the program's running time. `set_trace_func` is a no-go...

As an example, here's a valid solution being called with a one line program to count String#size calls:

    COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
    String#size called 50 times

Here's another more complex example:

    COUNT_CALLS_TO='B#foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; include A; end; 10.times{B.new.foo}'
    B#foo called 10 times
Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/method_logger`. To experiment with that code, run `bin/console` for an interactive prompt.

## The Gem

This gem, when installed, looks for the `COUNT_CALLS_TO` environment variable and logs the calls after each command in pry.

## Installation

Set the `COUNT_CALLS_TO` environment to the target method, ex. `String#size`.

Add this line to your application's Gemfile:

```ruby
gem 'method_logger', github: 'dysnomian/method_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install method_logger

## Usage

Fire up a pry console and enter your command to get the call count.
