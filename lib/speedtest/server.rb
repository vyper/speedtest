require 'net/http'
require 'ostruct'

module Speedtest
  class Server
    URL_FOR_ALL_SERVERS = 'http://www.speedtest.net/speedtest-servers.php'.freeze
    REGEX_FOR_PARSE = /<server url="([^"]*)" lat="([^"]*)" lon="([^"]*)/

    attr_reader :url, :localization

    def initialize(url:, latitude:, longitude:)
      @url = url
      @localization = OpenStruct.new(latitude: latitude, longitude: longitude)
    end

    def distance_from(origin)
      Math.sqrt((localization.longitude - origin.longitude) ** 2 + (localization.latitude - origin.latitude) ** 2)
    end

    def self.all
      uri = URI.parse(URL_FOR_ALL_SERVERS)
      request = Net::HTTP.get_response(uri)

      request.body.scan(REGEX_FOR_PARSE).map do |server|
        new(
          url: server[0].split(/(http:\/\/.*)\/speedtest.*/)[1],
          latitude: server[1].to_f,
          longitude: server[2].to_f
        )
      end
    end
  end
end
