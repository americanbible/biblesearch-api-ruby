class BibleSearch
  module Verses
    def verses(chapter_id, start_verse="", end_verse="")

      verses = []
      api_result = get_mash("/chapters/#{chapter_id}/verses.js", :query => {:start => start_verse, :end => end_verse})
      if api_result.meta.http_code == 200
        verses = pluralize_result(api_result.response.verses)
      end

      fumsify(api_result, verses)
    end

    def verse(verse_sig)

      # Validate a signature hash, calling its string sig equivalent if valid
      if verse_sig.is_a?(Hash)
        unless required_keys_present?(verse_sig, [:version_id, :book_id, :chapter, :verse])
          raise ArgumentError.new('Verse signature hash must include :version_id, :book_id, :chapter, and :verse')
        end

        return verse("#{verse_sig[:version_id]}:#{verse_sig[:book_id]}.#{verse_sig[:chapter]}.#{verse_sig[:verse]}")
      end

      # Validate a signature string, returning a verse Mash if valid and the
      # remote request succeeds
      if verse_sig.is_a?(String)
        unless verse_sig.match(/([A-Za-z0-9]+-)?[A-Za-z0-9]+:[A-Za-z0-9]+\.[0-9]+\.[0-9]+/)
          raise ArgumentError.new('Verse signature must be in the form "VERSION_ID:BOOK_ID.CHAPTER_NUMBER.VERSE_NUMBER"')
        end

        verse = nil
        api_result = get_mash("/verses/#{verse_sig}.js")
        if api_result.meta.http_code == 200
          verse = api_result.response.verses.first
        end

        return fumsify(api_result, verse)
      end
    end
  end
end
