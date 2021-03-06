# encoding: UTF-8

require "json"
require "net/http"

module Geogle
  class Base
    def initialize(settings = {})
      @settings    = settings
      @parametizer = Parametizer.new(settings)
      @raw         = settings[:raw] || false
    end

    protected

    def request(url, params)
      uri = UrlBuilder.new(url, @settings).build(params)
      begin
        response = Net::HTTP.get_response(uri)
        rescue Errno::ETIMEDOUT
          raise TimeOutError
      end
      raise InvalidKeyError if response.code == "403"
      raise TimeOutError if response.code == "408"
      raise ServerError if response.code[0] == "5"
      body = JSON.parse(response.body)
      ErrorHandler.check(body['status'])
      body
    end
  end
end
