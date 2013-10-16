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

  describe %{#verses} do
    describe %{referencing a non-existent book} do
      it %{returns an empty array} do
        @biblesearch.verses('eng-KJVA:NonexistentBook.1', '1', '16').must_equal []
      end
    end

    describe %{when requesting a chapter designated by a letter} do
      it %{doesn't raise an ArgumentError} do
        @biblesearch.verses('eng-GNTD:GEN.h', '5', '5').must_equal []
      end
    end

    describe %{when returning one verse} do
      before do
        @verses = @biblesearch.verses('eng-KJVA:John.3', '16', '16')
      end

      it %{has a collection} do
        @verses.collection.must_be_instance_of Array
      end

      it %{should contain one verse} do
        @verses.collection.length.must_equal 1
        @verses.collection.each do |verse|
          verse.must_respond_to(:auditid)
          verse.must_respond_to(:copyright)
          verse.must_respond_to(:id)
          verse.must_respond_to(:label)
          verse.must_respond_to(:lastverse)
          verse.must_respond_to(:next)
          verse.must_respond_to(:osis_end)
          verse.must_respond_to(:parent)
          verse.must_respond_to(:previous)
          verse.must_respond_to(:reference)
          verse.must_respond_to(:text)
          verse.must_respond_to(:verse)
          verse.wont_respond_to :footnotes
        end
      end

      it %{can include marginalia} do
        @verses = @biblesearch.verses('eng-KJVA:John.3', '16', '16', include_marginalia: true)
        @verses.collection.each do |verse|
          verse.must_include "footnotes"
        end
      end

    end

    describe %{when returning multiple verses} do
      before do
        @start_verse = 16
        @end_verse = 17
        @verses = @biblesearch.verses('eng-KJVA:John.3', @start_verse, @end_verse)
      end

      it %{has a collection} do
        @verses.collection.must_be_instance_of Array
      end

      it %{should contain the proper number of verses} do
        @verses.collection.length.must_equal(1 + @end_verse - @start_verse)
        @verses.collection.each do |verse|
          verse.must_respond_to(:auditid)
          verse.must_respond_to(:copyright)
          verse.must_respond_to(:id)
          verse.must_respond_to(:label)
          verse.must_respond_to(:lastverse)
          verse.must_respond_to(:next)
          verse.must_respond_to(:osis_end)
          verse.must_respond_to(:parent)
          verse.must_respond_to(:previous)
          verse.must_respond_to(:reference)
          verse.must_respond_to(:text)
          verse.must_respond_to(:verse)
          verse.wont_respond_to :footnotes
        end
      end

      it %{can include marginalia} do
        @verses = @biblesearch.verses('eng-KJVA:John.3', @start_verse, @end_verse, include_marginalia: true)
        @verses.collection.each do |verse|
          verse.must_include "footnotes"
        end
      end

    end
  end

  describe %{#verse} do
    describe %{given verse signature} do
      describe %{as a string} do
        it %{raises an argument error for bad input} do
          bad_verse_string = lambda { @biblesearch.verse('UnknownVersion') }
          bad_verse_string.must_raise ArgumentError
          (bad_verse_string.call rescue $!).message.must_equal 'Verse signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER.VERSE_NUMBER"'
        end
      end

      describe %{as a hash} do
        before do
          @options = {
            :version_id => 'eng-GNTD',
            :book_id => 'Acts',
            :chapter => '8',
            :verse => '34'
          }
        end
        describe %{if any pieces are missing} do
          it %{raises an argument error} do
            @options.keys.each do |key|
              options = @options
              options.delete(key)
              bad_verse_hash = lambda { @biblesearch.verse(options) }
              bad_verse_hash.must_raise ArgumentError
              (bad_verse_hash.call rescue $!).message.must_equal 'Verse signature hash must include :version_id, :book_id, :chapter, and :verse'
            end
          end
        end

        describe %{with a complete hash} do
          it %{returns the same thing as the equivalent string sig} do
            @biblesearch.verse(@options).value.must_equal @biblesearch.verse('eng-GNTD:Acts.8.34').value
          end

          it %{can include marginalia} do
            @biblesearch.verse(@options, include_marginalia: :true).value.must_equal @biblesearch.verse('eng-GNTD:Acts.8.34', include_marginalia: true).value
          end
        end
      end
    end

    describe %{when requesting a valid verse} do
      it %{has a verse value} do
        result = @biblesearch.verse('eng-GNTD:Acts.8.34').value
        result.must_be_instance_of Hashie::Mash
        result.must_respond_to(:auditid)
        result.must_respond_to(:copyright)
        result.must_respond_to(:id)
        result.must_respond_to(:label)
        result.must_respond_to(:lastverse)
        result.must_respond_to(:next)
        result.must_respond_to(:osis_end)
        result.must_respond_to(:parent)
        result.must_respond_to(:previous)
        result.must_respond_to(:reference)
        result.must_respond_to(:text)
        result.must_respond_to(:verse)
        result.wont_respond_to :footnotes
      end

      it %{can include marginalia} do
        result = @biblesearch.verse('eng-GNTD:Acts.8.34', include_marginalia: true).value
        result.must_include "footnotes"
      end

    end

    describe %{when requesting a verse designated by a letter} do
      it %{doesn't raise an ArgumentError} do
        #surprisingly, the API returns data for this verse
        @biblesearch.verse('eng-GNTD:GEN.6.z').wont_be_nil
      end
    end

    describe %{when requesting an invalid verse} do
      it %{returns nil} do
        @biblesearch.verse('eng-KJVA:NonexistentBook.1.1').must_be_nil
      end
    end
  end
end
