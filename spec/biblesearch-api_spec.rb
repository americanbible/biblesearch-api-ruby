require 'spec_helper'
require 'biblesearch-api'

describe BibleSearch do
  before do
    VCR.insert_cassette %{#{File.basename(__FILE__, '.rb')}-#{__name__}}
    @biblesearch = BibleSearch.new(BIBLESEARCH_API_KEY)
  end

  after do
    VCR.eject_cassette
  end

  describe %{.new} do
    it %{requires an API key as its first argument} do
      lambda {BibleSearch.new}.must_raise ArgumentError
      rigamaroe = BibleSearch.new('rigamaroe')
      rigamaroe.api_key.must_equal 'rigamaroe'
    end
    it %{accepts a base_uri as its second argument} do
      whatever = BibleSearch.new('whatever', 'lookatmybible.com')
      whatever.wont_be_nil
      whatever.class.base_uri.must_equal 'http://lookatmybible.com'
    end
  end

  describe %{#get_mash} do
    before do
      @api_result = @biblesearch.instance_eval('get_mash("/versions.js")')
    end

    it %{has metadata} do
      @api_result.must_respond_to(:meta)
      @api_result.meta.must_be_instance_of Hashie::Mash
    end

    it %{has a http response code in the metadata} do
      @api_result.meta.http_code.wont_be_nil
      @api_result.meta.http_code.must_be_kind_of Integer
    end

    it %{has a response} do
      @api_result.must_respond_to(:response)
    end

    describe %{in the sunny day scenario} do
      it %{has fums in the metadata} do
        @api_result.meta.must_respond_to(:fums)
        @api_result.meta.fums.wont_be_nil
      end

      it %{has a real response} do
        @api_result.response.wont_be_nil
        @api_result.must_be_instance_of Hashie::Mash
      end
    end

    describe %{when something goes wrong} do
      before do
        @api_result = @biblesearch.instance_eval('get_mash("/my-pokemons.js")')
      end

      it %{has a http response code other than 200} do
        @api_result.meta.http_code.wont_equal 200
      end

      it %{has a message in the metadata} do
        @api_result.meta.message.wont_be_nil
      end

      it %{has a nil response} do
        @api_result.response.must_be_nil
      end
    end
  end

  describe %{#pluralize_result} do
    describe %{returns an array} do
      it %{containing the contents of a passed array} do
        result = [1, 2, 3, 4]
        @biblesearch.instance_eval(%{pluralize_result([#{result.join(', ')}])}).must_equal result
      end

      it %{containing the singular value passed} do
        result = 1
        @biblesearch.instance_eval(%{pluralize_result(#{result})}).must_equal [result]
      end
    end
  end

  describe %{#fumsify} do
    describe %{given a good API Result} do
      before do
        @api_result = @biblesearch.send(:get_mash, '/versions.js')
      end

      describe %{and a plural value} do
        it %{returns a mash with a collection and a fums} do
          fumsified = @biblesearch.send(:fumsify, @api_result, [])
          fumsified.must_be_instance_of Hashie::Mash
          fumsified.fums.wont_be_nil
          fumsified.collection.must_be_kind_of(Array)
        end
      end

      describe %{and a singular value} do
        it %{returns a mash with a value and a fums} do
          [1, 'a', Hashie::Mash.new({:foo => 'bar'})].each do |value|
            fumsified = @biblesearch.send(:fumsify, @api_result, value)
            fumsified.must_be_instance_of Hashie::Mash
            fumsified.fums.wont_be_nil
            fumsified.value.must_equal value
          end
        end
      end
    end

    describe %{given a negative API Result} do
      before do
        @api_result = @biblesearch.send(:get_mash, '/my-pokemons.js')
      end

      it %{has a nil fums (same singular and plural behavior as good)} do
        collection = [1, 2, 3, 4]
        value = 1
        fumsified_plural = @biblesearch.send(:fumsify, @api_result, collection)
        fumsified_singular = @biblesearch.send(:fumsify, @api_result, value)

        fumsified_plural.fums.must_be_nil
        fumsified_plural.collection.must_equal collection

        fumsified_singular.fums.must_be_nil
        fumsified_singular.value.must_equal value
      end
    end
  end
end
