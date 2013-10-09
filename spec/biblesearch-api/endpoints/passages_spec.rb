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

  describe %{#passages} do
    describe %{when returning no passages} do
      before do
        @passages = @biblesearch.passages('Batman 1:1-16', :version => 'KJV')
      end
      it %{has a collection} do
        @passages.collection.must_be_instance_of Array
      end

      it %{should contain no passages} do
        @passages.collection.length.must_equal 0
      end
    end

    describe %{when returning a single passage} do
      before do
        @passages = @biblesearch.passages('John 3:16', :version => 'KJV')
      end
      it %{has a collection} do
        @passages.collection.must_be_instance_of Array
      end

      it %{should contain a single passage} do
        @passages.collection.size.must_equal 1
        @passages.collection.first.tap do |passage|
          passage.must_respond_to :display
          passage.must_respond_to :version
          passage.must_respond_to :version_abbreviation
          passage.must_respond_to :path
          passage.must_respond_to :start_verse_id
          passage.must_respond_to :end_verse_id
          passage.must_respond_to :text
          passage.must_respond_to :copyright
        end
      end
    end

    describe %{when returning multiple passages} do
      before do
        @passages = @biblesearch.passages('')
      end
      it %{has a collection} do
        @passages.collection.must_be_instance_of Array
      end
      it %{should contain passages} do
        @passages.collection.each do |passage|
          passage.must_respond_to :display
          passage.must_respond_to :version
          passage.must_respond_to :version_abbreviation
          passage.must_respond_to :path
          passage.must_respond_to :start_verse_id
          passage.must_respond_to :end_verse_id
          passage.must_respond_to :text
          passage.must_respond_to :copyright
        end
      end
    end

    describe %{when passing a list of bible version ids} do
      before do
        @versions = ['KJV', 'CEV']
        @passages = @biblesearch.passages('John 3:16', :versions => @versions)
      end

      it %{should provide the passage for each version specified} do
        @passages.collection.each do |passage|
          @versions.must_include passage.version
        end
      end
    end
  end
end
