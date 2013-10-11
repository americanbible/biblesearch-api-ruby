class BibleSearch

  CHAPTER_REGEX = /([A-Za-z0-9]+-)?[A-Za-z0-9]+:[A-Za-z0-9]+\.[0-9]+/

  def valid_chapter(chapter_sig)
    if chapter_sig.is_a?(Hash)
      begin
        # chapter_sig = chapter_sig.fetch(:version_id) + ':' + chapter_sig.fetch(:book_id) +  ".#{chapter_sig.fetch(:chapter)}"
        chapter_sig = "#{valid_book(chapter_sig)}.#{chapter_sig.fetch(:chapter)}"
      rescue
        raise ArgumentError.new('Chapter signature hash must include :version_id, :book_id, and :chapter')
      end
    end

    unless chapter_sig.match(CHAPTER_REGEX)
      raise ArgumentError.new('Chapter signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER"')
    end
    chapter_sig
  end

  module Chapters
    def chapters(book_sig)
      book_sig = valid_book(book_sig)
      chapters = []
      api_result = get_mash("/books/#{book_sig}/chapters.js")
      if api_result.meta.http_code == 200
        chapters = pluralize_result(api_result.response.chapters)
      end

      fumsify(api_result, chapters)
    end

    # def chapter(chapter_sig) #original
    def chapter(chapter_sig, options={}) #option 1
    # def chapter(options) #option 2 (options merged with sig, breaks string sig)
      chapter_sig = valid_chapter(chapter_sig)

      chapter = nil
      # uri += '?include_marginalia=true' if options.fetch(:include_marginalia, false)
      api_result = get_mash("/chapters/#{chapter_sig}.js", query: options)
      if api_result.meta.http_code == 200
        chapter = api_result.response.chapters.first
      end

      fumsify(api_result, chapter)
    end


  end
end
