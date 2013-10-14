# BibleSearch::API

* Stable Version 1.0.3: [![Build Status](https://travis-ci.org/americanbible/biblesearch-api-ruby.png?branch=master)](https://travis-ci.org/americanbible/biblesearch-api-ruby)
* Version 1.1.0: [![Build Status](https://travis-ci.org/americanbible/biblesearch-api-ruby.png?branch=1.1.0)](https://travis-ci.org/americanbible/biblesearch-api-ruby)


Ruby wrapper for BibleSearch API (bibles.org)

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
version = biblesearch.version('GNT')
# You can also add a language to a singular version
spanish_version = biblesearch.version('spa-GNT')

# Let's get some books
books = biblesearch.books('GNT')
# You can also provide a testament
old_testament_books = biblsearch.books('GNT', 'OT')
# A single book can be specified as a hash ...
book = biblesearch.book(:version_id => 'GNT', :book_id => '2Tim')
# ... or as a string
book = biblesearch.book('GNT:2Tim')

# Let's get some chapters for the book, either via hash ...
chapters = biblesearch.chapters(:version_id => 'GNT', :book_id => '2Tim')
# ... or string
chapters = biblesearch.chapters('GNT:2Tim')
# A single chapter can be specified as a hash ...
chapter = biblesearch.chapter(:version_id => 'GNT', :book_id => '2Tim', :chapter => 1)
# ... or as a string
chatper = biblesearch.chapter('GNT:2Tim.1')

# Let's get some verses
verses = biblesearch.verses("CEV:John.1","16","17")
# A single verse can be specified as a hash ...
verse = biblesearch.verse(:version_id => 'GNT', :book_id => 'Acts', :chapter => '8', :verse => '34')
# ... or as a string
verse = biblesearch.verse('GNT:Acts.8.34')

# Let's do a search
results = biblesearch.search('john 3:16') #passage search
results = biblesearch.search('mary') #keyword search

# Let's get some passages for a single version ...
passages = biblesearch.passages('john 3:16', :version => 'KJV')
# ... or for multiple versions
passages = biblesearch.passages('john 3:16', :versions => ['KJV', 'CEV'])
```

### Return values

All methods return a Hashie::Mash, and all of these mashes respond to #fums, which contains a string describing the FUMS for the call that was made.

Plural calls (#passages, #versions, #search, etc) respond to #collection with an array of mashes.

Singular calls (#version, #verse, etc) respond to #value with a mash.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Test against all supported rubies (`rake overtest` (see below))
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

### Supported Rubies

As of this release, the following MRI versions are verified as supported:

* 1.8.7
* 1.9.2-p180
* 1.9.3

In order to test against all of them, an "overtest" rake task is supplied that uses RVM to test against each of the supported versions. You will, however, have to bundle against each of them independently.
