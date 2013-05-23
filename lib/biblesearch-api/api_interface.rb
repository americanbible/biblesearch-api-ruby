require 'httparty'

module BibleSearch
  class APIInterface
    include HTTParty
    include Singleton

    no_follow = true
    format :json

    attr_accessor :api_key
    def initialize(api_key, base_uri = 'bibles.org/v2')
      self.class.base_uri base_uri
      self.class.basic_auth(@api_key = api_key, 'X')
    end

    private
      def mashup(response)
        Hashie::Mash.new(response)
      end

      def required_keys_present?(hash, required)
        hash.keys.sort_by {|key| key.to_s} == required.sort_by {|key| key.to_s}
      end

      def api_get(*args)
        api_response = self.class.get(*args)
        result = {}
        result['meta'] = {}
        begin
          result['meta'] = api_response['response'].delete('meta')
          result['response'] = api_response['response']
        rescue MultiJson::LoadError
          result['meta']['message'] = api_response.body
        ensure
          result['meta']['http_code'] = api_response.code
          return mashup(result)
        end
      end

      def pluralize_result(result)
        result.kind_of?(Array) ? result : [result]
      end

      def fumsify(api_result, value)
        fumsified = Hashie::Mash.new
        fumsified.fums = api_result.meta.fums

        if value.kind_of?(Array)
          fumsified.collection = value
        else
          fumsified.value = value
        end

        fumsified
      end
  end
end
