require 'spec_helper'
require 'biblesearch-api'

describe BibleSearch do
  before do
    VCR.insert_cassette %{endpoint-#{File.basename(__FILE__, '.rb')}-#{__name__}}
    # Here's how to force use of the server
    # VCR.insert_cassette %{endpoint-#{File.basename(__FILE__, '.rb')}-#{__name__}}, record: :all
    @biblesearch = BibleSearch.new(BIBLESEARCH_API_KEY)
  end

  after do
    VCR.eject_cassette
  end

  describe %{#chapters} do

    describe %{given a book signature} do
      describe %{as a string} do
        it %{raises an argument error for bad input} do
          bad_book_string = lambda { @biblesearch.chapters('UnknownVersion') }
          bad_book_string.must_raise ArgumentError
          (bad_book_string.call rescue $!).message.match /^Book signature must be in the form/
        end
      end

      describe %{as a hash} do
        before do
          @signature = {
            :version_id => 'eng-GNTD',
            :book_id => '2Tim'
          }
        end

        describe %{if any pieces are missing} do
          it %{raises an argument error} do
            @signature.keys.each do |key|
              options = @signature
              options.delete(key)
              bad_book_hash = lambda { @biblesearch.chapters(options) }
              bad_book_hash.must_raise ArgumentError
              (bad_book_hash.call rescue $!).message.match /^Book signature hash must include/
            end
          end
        end

        describe %{with a complete hash} do
          it %{returns the same thing as the equivalent string sig} do
            result = @biblesearch.chapters(@signature).collection
            result.wont_be_empty
            result.must_equal @biblesearch.chapters('eng-GNTD:2Tim').collection
          end
        end
      end
    end

    describe %{when I make a valid request} do
      before do
        @chapters = @biblesearch.chapters('eng-GNTD:2Tim')
      end

      it %{has a collection} do
        @chapters.collection.must_be_instance_of Array
      end

      it %{should contain chapters} do
        @chapters.collection.wont_be_empty
        @chapters.collection.each do |chapter|
          chapter.must_respond_to(:auditid)
          chapter.must_respond_to(:label)
          chapter.must_respond_to(:chapter)
          chapter.must_respond_to(:id)
          chapter.must_respond_to(:osis_end)
          chapter.must_respond_to(:parent)
          chapter.must_respond_to(:next)
          chapter.must_respond_to(:previous)
          chapter.must_respond_to(:copyright)
        end
      end
    end

    describe %{when I leave out the language code prefix} do
      it %{raises an argument error} do
        lambda {@biblesearch.chapters('CEV:GEN')}.must_raise ArgumentError
      end
    end

    describe %{when I ask for a book the API can't find} do
      before do
        @chapters = @biblesearch.chapters('eng-GNTD:NonexistentBook')
      end

      it %{returns an empty array} do
        @chapters.must_equal []
      end
    end
  end

  describe %{#chapter} do
    describe %{given a chapter signature} do
      describe %{as a string} do
        it %{raises an argument error for bad input} do
          bad_chapter_string = lambda { @biblesearch.chapter('UnknownVersion') }
          bad_chapter_string.must_raise ArgumentError
          (bad_chapter_string.call rescue $!).message.must_equal 'Chapter signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER"'
        end
      end

      describe %{as a hash} do
        before do
          @signature = {
            :version_id => 'eng-GNTD',
            :book_id => '2Tim',
            :chapter => 1
          }
        end

        describe %{if any pieces are missing} do
          it %{raises an argument error} do
            @signature.keys.each do |key|
              options = @signature
              options.delete(key)
              bad_chapter_hash = lambda { @biblesearch.chapter(options) }
              bad_chapter_hash.must_raise ArgumentError
              (bad_chapter_hash.call rescue $!).message.must_equal "Chapter signature hash must include :version_id, :book_id, and :chapter"
            end
          end
        end

        describe %{with a complete hash} do
          it %{returns the same thing as the equivalent string sig} do
            result = @biblesearch.chapter(@signature).value
            result.wont_be_empty
            result.must_equal @biblesearch.chapter('eng-GNTD:2Tim.1').value
          end
          it %{has verses} do
            @biblesearch.chapter(@signature).value.text.must_match /including Phygelus and Hermogenes/
          end
          it %{can be requested without marginalia} do
            result = @biblesearch.chapter(@signature)
            result.wont_be_empty
            result.value.wont_include("footnotes")
          end
          it %{can be requested with marginalia} do
            result = @biblesearch.chapter(@signature, include_marginalia: true)
            result.value.must_include("footnotes")
          end
        end
      end
    end

    describe %{when I make a valid request} do
      it %{has a chapter value} do
        result = @biblesearch.chapter('eng-GNTD:2Tim.1').value.tap do |chapter|
          chapter.must_respond_to(:auditid)
          chapter.must_respond_to(:label)
          chapter.must_respond_to(:chapter)
          chapter.must_respond_to(:id)
          chapter.must_respond_to(:osis_end)
          chapter.must_respond_to(:parent)
          chapter.must_respond_to(:next)
          chapter.must_respond_to(:previous)
          chapter.must_respond_to(:copyright)
        end
      end
    end

    describe %{when I ask for a chapter designated by a letter} do
      it %{doesn't raise an ArgumentError} do
        @biblesearch.chapter('eng-GNTD:GEN.h').must_be_nil
      end
    end

    describe %{when I request an invalid chapter} do
      it %{returns nil} do
        @biblesearch.chapter('eng-GNTD:NonexistentBook.1').must_be_nil
      end
    end
  end
end
