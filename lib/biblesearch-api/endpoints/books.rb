class BibleSearch

  # accept a hash or string book signature, validate it, and return a string
  def valid_book(book_sig)
    # if it's a hash, convert it to a string
    if book_sig.is_a?(Hash)
      begin
        book_sig = "#{book_sig.fetch(:version_id)}:#{book_sig.fetch(:book_id)}"
      rescue
        raise ArgumentError.new('Book signature hash must include :version_id and :book_id')
      end
    end

    # then check
    unless book_sig.match(@book_re)
      raise ArgumentError.new('Book signature must be in the form "LANGUAGE_ID-VERSION_ID:BOOK_ID"')
    end
    book_sig
  end

  module Books
    def books(version_id, options={})
      defaults = {testament_id: nil, include_chapters: false}
      options = defaults.merge(options)
      testament_id = options[:testament_id]
      include_chapters = options[:include_chapters]

      api_endpoint = "/versions/#{version_id}/books.js"
      api_endpoint += "?testament=#{testament_id}" unless testament_id.nil?
      api_endpoint += "?include_chapters=true" if include_chapters

      unless @version_re.match(version_id)
        raise ArgumentError.new('version_id must be in the form "LANGUAGE_CODE-VERSION_ID:BOOK_ID"')
      end

      api_result = get_mash(api_endpoint)

      if api_result.meta.http_code == 200
        books = []
        books = pluralize_result(api_result.response.books)
        fumsify(api_result, books)
      else
        []
      end
    end

    def book(book_sig)
      book_sig = valid_book(book_sig)

      api_result = get_mash("/books/#{book_sig}.js")
      if api_result.meta.http_code == 200
        book = nil
        book = api_result.response.books.first
        fumsify(api_result, book)
      else
        nil
      end

    end


  end
end
