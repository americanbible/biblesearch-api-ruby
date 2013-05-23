require 'spec_helper'
require 'biblesearch-api'

describe BibleSearch do
  before do
    VCR.insert_cassette %{endpoint-#{File.basename(__FILE__, '.rb')}-#{__name__}}
    @biblesearch = BibleSearch.new('DUMMY_API_KEY')
  end

  after do
    VCR.eject_cassette
  end

  describe %{books} do
    it %{requires a version id} do
      lambda { @biblesearch.books }.must_raise ArgumentError
      (lambda { @biblesearch.books('GNT') }.call rescue $!).wont_be_kind_of ArgumentError
    end

    it %{accepts an optional testament id} do
      all_cool = lambda { @biblesearch.books('GNT', 'OT') }
      (all_cool.call rescue $!).wont_be_kind_of ArgumentError
    end

    describe %{when I make a valid request} do
      before do
        @books = @biblesearch.books('GNT')
      end

      it %{has a collection} do
        @books.collection.must_be_kind_of(Array)
      end

      it %{contains books} do
        @books.collection.length.must_be :>, 0
        @books.collection.each do |book|
          book.must_respond_to(:version_id)
          book.must_respond_to(:name)
          book.must_respond_to(:abbr)
          book.must_respond_to(:ord)
          book.must_respond_to(:book_group_id)
          book.must_respond_to(:testament)
          book.must_respond_to(:id)
          book.must_respond_to(:osis_end)
          book.must_respond_to(:parent)
          book.must_respond_to(:copyright)
        end
      end
    end

    describe %{when I make a bad request} do
      before do
        @books = @biblesearch.books('SupDawg')
      end

      it %{has a collection} do
        @books.collection.must_be_instance_of Array
      end

      it %{contains no items} do
        @books.collection.length.must_equal 0
      end
    end

  end

  describe %{book} do
    describe %{given a book signature} do
      describe %{as a string} do
        it %{raises an argument error for bad input} do
          bad_book_string = lambda { @biblesearch.book('SupDawg') }
          bad_book_string.must_raise ArgumentError
          (bad_book_string.call rescue $!).message.must_equal 'Book signature must be in the form "VERSION_ID:BOOK_ID"'
        end
      end

      describe %{as a hash} do
        before do
          @options = {
            :version_id => 'GNT',
            :book_id => '2Tim'
          }
        end

        describe %{if any pieces are missing} do
          it %{raises an argument error} do
            @options.keys.each do |key|
              options = @options
              options.delete(key)
              bad_book_hash = lambda { @biblesearch.book(options) }
              bad_book_hash.must_raise ArgumentError
              (bad_book_hash.call rescue $!).message.must_equal 'Book signature hash must include :version_id and :book_id'
            end
          end
        end

        describe %{with a complete hash} do
          it %{returns the same thing as the equivalent string sig} do
            @biblesearch.book(@options).value.must_equal @biblesearch.book('GNT:2Tim').value
          end
        end
      end

      describe %{when I make a valid request} do
        it %{has a book value} do
          @biblesearch.book('GNT:2Tim').value.tap do |book|
            book.must_respond_to(:version_id)
            book.must_respond_to(:name)
            book.must_respond_to(:abbr)
            book.must_respond_to(:ord)
            book.must_respond_to(:book_group_id)
            book.must_respond_to(:testament)
            book.must_respond_to(:id)
            book.must_respond_to(:osis_end)
            book.must_respond_to(:parent)
            book.must_respond_to(:copyright)
          end
        end
      end

      describe %{when I request an invalid book} do
        it %{returns nil} do
          @biblesearch.book('GNT:Batman').value.must_be_nil
        end
      end
    end
  end
end
