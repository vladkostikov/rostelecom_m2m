# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

class RostelecomM2M
  attr_accessor :login, :password, :auth_token, :debug

  VERSION = "1.0.0"

  def initialize(parameters = {})
    self.login = parameters[:login]
    self.password = parameters[:password]
    self.auth_token = parameters[:auth_token]
    self.debug = parameters[:debug] || false
  end

  def get(url, parameters = {})
    uri = URI.parse("https://m2m.rt.ru/openapi/v1#{url}")
    uri.query = URI.encode_www_form(parameters)
    request = Net::HTTP::Get.new(uri)

    validate_response(make_request(request, uri))
  end

  def post(url, parameters = {})
    uri = URI.parse("https://m2m.rt.ru/openapi/v1#{url}")
    uri.query = URI.encode_www_form(parameters)
    request = Net::HTTP::Post.new(uri)

    validate_response(make_request(request, uri))
  end

  protected

  def make_request(request, uri)
    print_debug_message(request) if debug

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def validate_response(response)
    case response.code.to_i
    when 200, 204
      { error: false, message: JSON.parse(response.body) }
    else
      { error: true, message: JSON.parse(response.body) }
    end
  end

  def print_debug_message(request)
    puts "================ ROSTELECOM REQUEST ================"
    puts "Request: #{request.method} #{request.uri.host + request.uri.path}"
    puts "Parameters: #{URI.decode_www_form(request.uri.query).to_h}"
    puts "================================================"
  end
end
