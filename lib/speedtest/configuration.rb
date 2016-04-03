require 'ostruct'

module Speedtest
  class Configuration
    URL_FOR_CONFIG = 'http://www.speedtest.net/speedtest-config.php'.freeze
    REGEX_FOR_PARSE = /<client ip="([^"]*)" lat="([^"]*)" lon="([^"]*)"/

    def ip
      @ip ||= parsed_body[0]
    end

    def localization
      @localization ||= begin
        OpenStruct.new(
          latitude: parsed_body[1].to_f,
          longitude: parsed_body[2].to_f)
      end
    end

    private

    def request
      uri = URI.parse(URL_FOR_CONFIG)
      Net::HTTP.get_response(uri).body
    end

    def parsed_body
      @parsed_body ||= request.scan(REGEX_FOR_PARSE).first
    end
  end
end
