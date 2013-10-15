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

  describe %{the Books endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.books('eng-GNTD').fums.wont_be_nil
      @biblesearch.book('eng-GNTD:2Tim').fums.wont_be_nil
    end

    it %{raises ArgumentError for bad requests} do
      lambda {@biblesearch.books('CEV')}.must_raise ArgumentError
      lambda {@biblesearch.book('CEV:NonexistentBook')}.must_raise ArgumentError
    end
  end

  describe %{the Chapters endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.chapters('eng-GNTD:2Tim').fums.wont_be_nil
      @biblesearch.chapter('eng-GNTD:2Tim.1').fums.wont_be_nil
    end

    it %{raises ArgumentError for bad requests} do
      lambda {@biblesearch.chapters('CEV:NonexistentBook')}.must_raise ArgumentError
      lambda {@biblesearch.chapter('CEV:NonexistentBook.1')}.must_raise ArgumentError
    end
  end

  describe %{the Passages endpoint} do
    it %{has real fums for all requests} do
      @biblesearch.passages('John 3:16', :version => 'eng-KJVA').fums.wont_be_nil
      @biblesearch.passages('NonexistentBook 13:17', :version => 'DCU').fums.wont_be_nil
    end
  end

  describe %{the Search endpoint} do
    it %{has real fums for all requests} do
      @biblesearch.search('john 3:16').fums.wont_be_nil
      @biblesearch.search('NonexistentBook 13:17').fums.wont_be_nil
    end
  end

  describe %{the Verses endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.verses('eng-KJVA:John.3', '16', '16').fums.wont_be_nil
      @biblesearch.verse('eng-GNTD:Acts.8.34').fums.wont_be_nil
    end

    it %{raises ArgumentError for bad requests} do
      lambda {@biblesearch.verses('CEV:NonexistentBook', '13', '17')}.must_raise ArgumentError
      lambda {@biblesearch.verses('KJVA:NonexistentBook.1.2')}.must_raise ArgumentError
    end
  end

  describe %{the Versions endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.versions.fums.wont_be_nil
      @biblesearch.version('eng-GNTD').fums.wont_be_nil
    end

    it %{raises ArgumentError for bad requests} do
      lambda {@biblesearch.version('CEV')}.must_raise ArgumentError
    end
  end

end
