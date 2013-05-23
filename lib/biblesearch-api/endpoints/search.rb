class BibleSearch
  module Search
    def search(query, options = {})
      options = options.merge({:query => query})

      result = Hashie::Mash.new
      api_result = get_mash("/search.js", :query => options)

      if api_result.meta.http_code == 200
        api_result.response.search.tap do |search_response|
          result.type = search_response.result.type
          result.summary = search_response.result.summary
          if result.type == 'passages'
            result.passages = pluralize_result(search_response.result.passages)
          elsif result.type == 'verses'
            result.verses = pluralize_result(search_response.result.verses)
          end
        end
      end

      fumsify(api_result, result)
    end
  end
end
