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

  describe %{#versions} do
    before do
      @versions = @biblesearch.versions
    end

    it %{has a collection} do
      @versions.collection.must_be_instance_of Array
    end

    it %{should contain versions} do
      @versions.collection.length.must_be :>, 0
      @versions.collection.each do |version|
        version.must_respond_to(:id)
        version.must_respond_to(:name)
        version.must_respond_to(:lang)
        version.must_respond_to(:lang_code)
        version.must_respond_to(:lang_name_eng)
        version.must_respond_to(:abbreviation)
        version.must_respond_to(:copyright)
        version.must_respond_to(:contact_url)
        version.must_respond_to(:info)
      end
    end

    describe %{when I provide a language} do
      describe %{that has representative versions on the remote end} do
        before do
          @spanish_versions = @biblesearch.versions(:language => 'spa')
        end
        it 'should return only those representative versions' do
          @spanish_versions.collection.each do |version|
            version.lang.must_equal 'spa'
          end
        end
      end

      describe %{that has no representative versions on the remote end} do
        before do
          @klingon_versions = @biblesearch.versions(:language => 'klingon')
        end
        it %{has a collection} do
          @klingon_versions.collection.must_be_instance_of Array
        end
        it %{should be empty} do
          @klingon_versions.collection.length.must_equal 0
        end
      end
    end
  end

  describe %{#version} do
    it %{requires a version id} do
      lambda { @biblesearch.version }.must_raise ArgumentError
    end

    describe %{with a valid version id} do
      it %{has a version value} do
        result = @biblesearch.version('eng-GNTD').value
        result.must_be_instance_of Hashie::Mash
        result.must_respond_to(:id)
        result.must_respond_to(:name)
        result.must_respond_to(:lang)
        result.must_respond_to(:lang_code)
        result.must_respond_to(:lang_name_eng)
        result.must_respond_to(:abbreviation)
        result.must_respond_to(:copyright)
        result.must_respond_to(:contact_url)
        result.must_respond_to(:info)
      end
    end

    describe %{with an invalid version id} do
      it %{a nonexistent version with a language code returns nil} do
        # skip "refactoring"
        @biblesearch.version('eng-NONEXISTENTVERSION').must_be_nil
      end
      it %{a real version without a language code raises an ArgumentError} do
        # skip "refactoring"
        lambda {@biblesearch.version('CEV')}.must_raise ArgumentError
      end

    end
  end
end
