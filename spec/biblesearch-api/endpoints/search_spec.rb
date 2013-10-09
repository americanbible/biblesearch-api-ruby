require 'spec_helper'
require 'biblesearch-api'

describe BibleSearch do
  before do
    VCR.insert_cassette %{endpoint-#{File.basename(__FILE__, '.rb')}-#{__name__}}
    @biblesearch = BibleSearch.new(BIBLESEARCH_API_KEY)
  end

  after do
    VCR.eject_cassette
  end

  describe %{#search} do
    it %{has a Hashie::Mash value} do
      @biblesearch.search('john 3:16').value.must_be_instance_of Hashie::Mash
      @biblesearch.search('Mahershalalhashbaz').value.must_be_instance_of Hashie::Mash
    end

    describe %{when doing a passage search} do
      it %{returns passages} do
        result = @biblesearch.search('john 3:16').value
        result.type.must_equal 'passages'
        result.must_respond_to(:passages)
      end
    end

    describe %{when doing a keyword search} do
      it %{returns verses} do
        result = @biblesearch.search('Mahershalalhashbaz').value
        result.type.must_equal 'verses'
        result.must_respond_to(:verses)
      end
    end
  end
end
