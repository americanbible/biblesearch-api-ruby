# BibleSearch::API Tests


## Quickstart

The built-in tests are fairly standard [minitests](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest/Unit/TestCase.html. They use the [VCR Gem](https://github.com/vcr/vcr) to fake API interaction.

1. Run `bundle install`
1. Run `rake test`

For development document #TODO:

1. `rake focus` and `rake test TEST=<filename>`
1. `xdescribe`
1. `BIBLESEARCH_API_KEY` plus delete cassettes to re-record.

## Helpful Details

### API Keys

### Cassettes

If you're working on a set of tests and want them to always hit the API, put this in their before. Don't forget to remove it when done.

    VCR.insert_cassette %{endpoint-#{File.basename(__FILE__, '.rb')}-#{__name__}}, record: :all

### Focus and xDescribe

`xdescribe` lets you omit example groups.

The `rake test:focus` task lets you filter the minitests runs during development.

### Guard

`bundle exec guard`

