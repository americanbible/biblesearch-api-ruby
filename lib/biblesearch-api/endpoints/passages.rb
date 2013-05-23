class BibleSearch
  module Passages
    def passages(passage, options = {})
      versions = options.delete(:versions)
      unless versions.nil?
        if versions.is_a?(Array)
          versions = versions.join(',')
        end
        options[:version] = versions
      end
      options = options.merge({"q[]" => passage})

      passages = []
      api_result = get_mash("/passages.js", :query => options)
      if api_result.meta.http_code == 200
        passages = pluralize_result(api_result.response.search.result.passages)
      end

      fumsify(api_result, passages)
    end
  end
end
