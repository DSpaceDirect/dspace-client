# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"
require "minitest/autorun"
require "faraday"
require "json"

module Minitest
  class Test
    def build_client(stub)
      config = DSpace::Configuration.new(settings: {
                                           adaptor: :test,
                                           rest_url: "https://example.dspace.org/server/api",
                                           username: "admin@dspacedirect.org",
                                           password: "admin",
                                           stubs: stub
                                         })
      DSpace::Client.new(config: config)
    end

    def stub_response(fixture:, status: 200, headers: { "Content-Type" => "application/json" })
      [status, headers, File.read("test/fixtures/#{fixture}.json")]
    end

    def stub_request(path, response:, method: :get, body: {})
      Faraday::Adapter::Test::Stubs.new do |stub|
        arguments = [method, "server/api/#{path}"]
        arguments << body.to_json if %i[post put patch].include?(method)
        stub.send(*arguments) { |_env| response }
      end
    end
  end
end
