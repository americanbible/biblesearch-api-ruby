# BibleSearch::API

Ruby wrapper for [BibleSearch API](http://tools.bibles.org). An example Rails application is at [biblesearch-example-rails](https://github.com/americanbible/biblesearch-example-rails).

## Status

Gem hosted at [RubyGems](http://rubygems.org/gems/biblesearch-api), API docs at [RubyDoc](http://rubydoc.info/gems/biblesearch-api).

* [![Build Status](https://travis-ci.org/americanbible/biblesearch-api-ruby.png?branch=master)](https://travis-ci.org/americanbible/biblesearch-api-ruby): Stable Version
* [![Build Status](https://travis-ci.org/americanbible/biblesearch-api-ruby.png?branch=develop)](https://travis-ci.org/americanbible/biblesearch-api-ruby): Development Version

## Installation

Add this line to your application's Gemfile:

    gem 'biblesearch-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biblesearch-api

## Usage

```ruby
biblesearch = BibleSearch.new('YOUR_API_KEY')

# Let's get some versions
versions = biblesearch.versions
spanish_versions = biblesearch.versions(:language => 'spa')

# When you request a version, you'll need to include it's language-code prefix
version = biblesearch.version('spa-TLA')

# Let's get some books
books = biblesearch.books('spa-TLA')
# You can also provide a testament
old_testament_books = biblsearch.books('spa-TLA', 'OT')
# A single book can be specified as a hash ...
book = biblesearch.book(:version_id => 'spa-TLA', :book_id => '2Tim')
# ... or as a string
book = biblesearch.book('spa-TLA:2Tim')

# Let's get some chapters for the book, either via hash ...
chapters = biblesearch.chapters(:version_id => 'spa-TLA', :book_id => '2Tim')
# ... or string
chapters = biblesearch.chapters('spa-TLA:2Tim')
# A single chapter can be specified as a hash ...
chapter = biblesearch.chapter(:version_id => 'spa-TLA', :book_id => '2Tim', :chapter => 1)
# ... or as a string
chatper = biblesearch.chapter('spa-TLA:2Tim.1')

# Let's get some verses
verses = biblesearch.verses("eng-CEV:John.1","16","17")
# A single verse can be specified as a hash ...
verse = biblesearch.verse(:version_id => 'spa-TLA', :book_id => 'Acts', :chapter => '8', :verse => '34')
# ... or as a string
verse = biblesearch.verse('spa-TLA:Acts.8.34')

# Let's do a search
results = biblesearch.search('john 3:16') #passage search
results = biblesearch.search('mary') #keyword search

# Let's get some passages for a single version ...
passages = biblesearch.passages('john 3:16', :version => 'eng-KJVA')
# ... or for multiple versions
passages = biblesearch.passages('john 3:16', :versions => ['eng-KJVA', 'eng-CEV'])
```

### Return values

All methods return a [Hashie::Mash](https://github.com/intridea/hashie#mash), and all of these mashes respond to #fums, which contains a string describing the FUMS for the call that was made.

Plural calls (#passages, #versions, #search, etc) respond to #collection with an array of mashes.

Singular calls (#version, #verse, etc) respond to #value with a mash.

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Run tests and verify they pass
1. Commit your changes (`git commit -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new [Pull Request](https://help.github.com/articles/using-pull-requests/)

### Configure Environment for Tests

To successfully run the tests, you first need to export your Bible API key for availability in the tests.  To do this on Mac OS X or Linux based shells, type the following in your shell (or put it in your `.bashrc`, `.zshrc` file):

```shell
export BIBLESEARCH_API_KEY=YOUR_API_KEY
```

with `YOUR_API_KEY` replaced by your actual API key.  Without exporting the key, some of the tests will fail.

This environment variable is imported by the `spec_helper.rb` file and used by several of the tests.

### Running Tests

1. Test your code with `rake test:all` frequently.
1. Add tests for your new features. (*Note*  this Gem uses the `minitest` framework, not `RSpec`, despite the `spec/` directory name.)
1. Test against all supported rubies (`rake test:overtest` (see below)).

### Supported Rubies

As of this release, the following MRI versions are verified as supported:

* 1.9.3
* 2.0.0
* 2.1.3

In order to test against all of them, an "test:overtest" rake task is supplied that uses RVM to test against each of the supported versions. You will, however, have to bundle against each of them independently.
