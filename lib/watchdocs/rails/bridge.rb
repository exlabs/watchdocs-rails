module Watchdocs
  module Bridge
    class WatchdocsApiError < StandardError; end

    DEFAULT_ERROR = 'Unknown API Error occured.'.freeze

    class << self
      def send(payload)
        response = HTTParty.post(
          api_url,
          body: payload.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        check_response(response)
      end

      private

      def check_response(response)
        case response.code.to_s.chars.first
        when '2'
          true
        when '4', '5'
          raise WatchdocsApiError, get_error(response.body)
        else
          raise WatchdocsApiError, DEFAULT_ERROR
        end
      end

      def get_error(response_body)
        JSON.parse(response_body)['errors'].join(', ')
      rescue
        DEFAULT_ERROR
      end

      def api_url
        'http://demo8792890.mockable.io/requests'
      end
    end
  end
end