class BibleSearch

  def valid_verse(verse_sig)
    if verse_sig.is_a?(Hash)
      begin
        verse_sig = "#{valid_chapter(verse_sig)}.#{verse_sig[:verse]}"
      rescue
        raise ArgumentError.new('Verse signature hash must include :version_id, :book_id, :chapter, and :verse')
      end
    end

    # Validate a signature string, returning a verse Mash if valid and the
    # remote request succeeds
    unless verse_sig.match(@verse_re)
      raise ArgumentError.new('Verse signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER.VERSE_NUMBER"')
    end
    verse_sig
  end

  module Verses
    def verses(chapter_id, start_verse="", end_verse="", options={})
      unless chapter_id.match(@chapter_re)
        raise ArgumentError.new('Chapter signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER"')
      end

      api_result = get_mash("/chapters/#{chapter_id}/verses.js", :query => {:start => start_verse, :end => end_verse}.merge(options))
      if api_result.meta.http_code == 200
        verses = []
        verses = pluralize_result(api_result.response.verses)
        fumsify(api_result, verses)
      else
        # raise ArgumentError.new("Unrecognized verses request.")
        []
      end

    end

    def verse(verse_sig, options={})

      # Validate a signature hash, calling its string sig equivalent if valid
      verse_sig = valid_verse(verse_sig)

      api_result = get_mash("/verses/#{verse_sig}.js", query: options)
      if api_result.meta.http_code == 200
        verse = nil
        verse = api_result.response.verses.first
        return fumsify(api_result, verse)
      else
        # raise ArgumentError.new("Unrecognized verses request.")
        nil
      end

    end

  end
end
