class BibleSearch
  module Chapters
    def chapters(book_sig)
      if book_sig.is_a?(Hash)
        unless required_keys_present?(book_sig, [:version_id, :book_id])
          raise ArgumentError.new('Book signature hash must include :version_id and :book_id')
        end

        return chapters("#{book_sig[:version_id]}:#{book_sig[:book_id]}")
      end

      unless book_sig.match(/([A-Za-z0-9]+-)?[A-Za-z0-9]+:[A-Za-z0-9]+/)
        raise ArgumentError.new('Book signature must be in the form "VERSION_ID:BOOK_ID"')
      end

      chapters = []
      api_result = get_mash("/books/#{book_sig}/chapters.js")
      if api_result.meta.http_code == 200
        chapters = pluralize_result(api_result.response.chapters)
      end

      fumsify(api_result, chapters)
    end

    def chapter(chapter_sig)
      if chapter_sig.is_a?(Hash)
        unless required_keys_present?(chapter_sig, [:version_id, :book_id, :chapter])
          raise ArgumentError.new('Chapter signature hash must include :version_id, :book_id, and :chapter')
        end

        return chapter("#{chapter_sig[:version_id]}:#{chapter_sig[:book_id]}.#{chapter_sig[:chapter]}")
      end

      unless chapter_sig.match(/([A-Za-z0-9]+-)?[A-Za-z0-9]+:[A-Za-z0-9]+\.[0-9]+/)
        raise ArgumentError.new('Chapter signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER"')
      end

      chapter = nil
      api_result = get_mash("/chapters/#{chapter_sig}.js")
      if api_result.meta.http_code == 200
        chapter = api_result.response.chapters.first
      end

      fumsify(api_result, chapter)
    end
  end
end
