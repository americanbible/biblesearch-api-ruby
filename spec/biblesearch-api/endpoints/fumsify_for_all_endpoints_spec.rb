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

    it %{has nil fums for bad requests} do
      @biblesearch.books('Gotham').fums.must_be_nil
      @biblesearch.book('Gotham:NonexistentBook').fums.must_be_nil
    end
  end

  describe %{the Chapters endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.chapters('eng-GNTD:2Tim').fums.wont_be_nil
      @biblesearch.chapter('eng-GNTD:2Tim.1').fums.wont_be_nil
    end

    it %{has nil fums for bad requests} do
      @biblesearch.chapters('Gotham:NonexistentBook').fums.must_be_nil
      @biblesearch.chapter('Gotham:Bataman.1').fums.must_be_nil
    end
  end

  describe %{the Passages endpoint} do
    it %{has real fums for all requests} do
      @biblesearch.passages('John 3:16', :version => 'KJV').fums.wont_be_nil
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
      @biblesearch.verses('KJV:John.3', '16', '16').fums.wont_be_nil
      @biblesearch.verse('eng-GNTD:Acts.8.34').fums.wont_be_nil
    end

    it %{has nil fums for bad requests} do
      @biblesearch.verses('Gotham:NonexistentBook', '13', '17').fums.must_be_nil
      @biblesearch.verses('Metropolis:Superman.1.2').fums.must_be_nil
    end
  end

  describe %{the Versions endpoint} do
    it %{has real fums for all valid requests} do
      @biblesearch.versions.fums.wont_be_nil
      @biblesearch.version('eng-GNTD').fums.wont_be_nil
    end

    it %{has nil fums for bad requests} do
      @biblesearch.version('Gotham').fums.must_be_nil
    end
  end

end
