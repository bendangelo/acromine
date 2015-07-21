# Acromine Client

* home :: https://github.com/jf647/acromine
* license :: [MIT](http://opensource.org/licenses/MIT)
* gem version :: [![Gem Version](https://badge.fury.io/rb/acromine.png)](http://badge.fury.io/rb/acromine)
* build status :: [![Circle CI](https://circleci.com/gh/jf647/acromine.svg?style=svg)](https://circleci.com/gh/jf647/acromine)
* code climate :: [![Code Climate](https://codeclimate.com/github/jf647/acromine/badges/gpa.svg)](https://codeclimate.com/github/jf647/acromine)
* docs :: [![Inline docs](http://inch-ci.org/github/jf647/acromine.svg?branch=master)](http://inch-ci.org/github/jf647/acromine)

## DESCRIPTION

acromine is a client for the [Acromine REST
Service](http://www.nactem.ac.uk/software/acromine/rest.html) provided
by the National Centre for Text Mining.

This gem provides a library to easily find the long form of an acronym.

A CLI is also provided to use the library from the command line.

## SYNOPSIS

    require 'acromine'

    acro = Acromine.new
    puts "HMM may refer to:"
    acro.longforms('HMM').variants.each do |lf|
      puts "  #{lf.longform}"
    end

## INSTALLATION

    gem install acromine

## REQUIREMENTS

* ruby 2.x or higher
    * tested with MRI 2.2.2

## LIBRARY USAGE

First, construct an Acromine object:

    require 'acromine'
    acro = Acromine.new

The object has one method `#longforms`, which takes a single acronym as
an argument and returns a list of Acromine::Longform objects.  If the
acronym is not found, the list will be empty.

Each Longform object has four getter methods:

* `#longform` which returns the long form of the acronym
* `#frequency` which returns the number of occurences of the acronym
* `#since` which returns the year the definition first appears in the Acromine corpus
* `#variants`, which returns a list of Acromine::LongformVariant objects.

Each Longform will always have at least one LongformVariant.  

To limit the number of variants returned, pass a limit in an options
hash:

    acro.longforms('HMM').variants(limit: 5)

Variants will be sorted by descending frequency count then by ascending
variant year and finally by ascending long form.

This order can be changed using the 'sort_spec' option. The spec is one
or two two-character pairs joined by a comma.  The first character of
the pair is what to sort - f for the frequency and y for the year.  The
second character of the pair is how to sort - a for ascending and d for
descending:

    acro.longforms('HMM').variants(sort_spec: 'fa,yd')

A LongformVariant object has three getter methods:

* `#longform` which returns the long form of the acronym
* `#freq` which returns the number of occurences of the acronym
* `#since` which returns the year the definition first appears in the Acromine corpus

To view the full documentation, refer to the DEVELOPMENT section below.

## CLI USAGE

    acromine lf [--limit N] [--sort SPEC] ACRONYM

Help can be displayed for global options:

    acromine help

Or for a individual command:

    acromine help lf

### CONFIG FILE

The CLI options can have their defaults set via a config file.  To
create it, run:

    acromine initconfig

which will create the file `~/.acromine.conf`.  The defaults will be
written to this file, which can be edited as desired.  For example, the
following file sets the sort order to oldest then by most used and sets
a limit of 5:

```
---
commands:
  :longform:
    :sort: yd,fd
    :limit: 5
```

## DEVELOPMENT

To set up for development, run

    bundle

To run tests, run

    bundle exec rake spec      # unit tests
    bundle exec rake features  # feature tests
    bundle exec rake test      # all tests

Unit tests use a mocked source, while feature tests require internet
access to the Acromine service.

To run tests automatically when the source changes, start guard:

    bundle exec guard

To generate a code coverage report, run

    bundle exec rake coverage

The report will be generated in the `coverage` subdirectory. Open
`index.html` in this directory to start browsing

To generate library documentation, run

    bundle exec rake doc

The rdoc will be generated in the `doc` subdirectory.  Open `index.html`
in this directory to start browsing the documentation.

## LICENSE

(The MIT License)

Copyright (c) 2015, James FitzGibbon

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## AUTHOR

James FitzGibbon <james@nadt.net>
