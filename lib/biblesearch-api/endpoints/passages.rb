class BibleSearch
  module Passages
    def passages(passage, options = {})
      versions = options.delete(:versions)
      unless versions.nil?
        if versions.is_a?(String)
          versions = versions.split(',')
        end
        options[:version] = versions.join(',')
      end
      options = options.merge({"q[]" => passage})

      api_result = get_mash("/passages.js", :query => options)
      if api_result.meta.http_code == 200
        passages = []
        passages = pluralize_result(api_result.response.search.result.passages)
        fumsify(api_result, passages)
      else
        []
      end
    end
  end
end
