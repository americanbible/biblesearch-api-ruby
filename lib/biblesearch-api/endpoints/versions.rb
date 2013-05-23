class BibleSearch
  module Versions
    def versions(options = {})
      api_endpoint = '/versions.js'
      unless options[:language].nil?
        api_endpoint += %{?language=#{options[:language]}}
      end

      versions = []
      api_result = get_mash(api_endpoint)
      if api_result.meta.http_code == 200
        versions = pluralize_result(api_result.response.versions)
      end

      fumsify(api_result, versions)
    end

    def version(version_id)
      version = nil
      api_result = get_mash("/versions/#{version_id.upcase}.js")
      if api_result.meta.http_code == 200
        version = api_result.response.versions.first
      end
    
      fumsify(api_result, version)
    end
  end
end
