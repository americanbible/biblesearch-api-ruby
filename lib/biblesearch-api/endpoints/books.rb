class BibleSearch
  module Books
    def books(version_id, options={})
      defaults = {testament_id: nil, include_chapters: false}
      options = defaults.merge(options)
      testament_id = options[:testament_id]
      include_chapters = options[:include_chapters]

      api_endpoint = "/versions/#{version_id}/books.js"
      api_endpoint += "?testament=#{testament_id}" unless testament_id.nil?
      api_endpoint += "?include_chapters=true" if include_chapters

      api_result = get_mash(api_endpoint)

      books = []
      if api_result.meta.http_code == 200
        books = pluralize_result(api_result.response.books)
      end

      fumsify(api_result, books)
    end

    def book(book_sig)
      if book_sig.is_a?(Hash)
        unless required_keys_present?(book_sig, [:version_id, :book_id])
          raise ArgumentError.new('Book signature hash must include :version_id and :book_id')
        end
        return book("#{book_sig[:version_id]}:#{book_sig[:book_id]}")
      end

      unless book_sig.match(/([A-Za-z0-9]+-)?[A-Za-z0-9]+:[A-Za-z0-9]+/)
        raise ArgumentError.new('Book signature must be in the form "VERSION_ID:BOOK_ID"')
      end

      book = nil
      api_result = get_mash("/books/#{book_sig}.js")
      if api_result.meta.http_code == 200
        book = api_result.response.books.first
      end

      fumsify(api_result, book)
    end
  end
end
