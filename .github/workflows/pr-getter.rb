#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

def main
  github_token = ENV.fetch('TOKEN')
  url = ENV.fetch('PR_URL')

  res = fetch(url, { token: github_token })
  puts res['head']
end

def fetch(url, option)
  uri = URI.parse(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'

  req = Net::HTTP::Get.new(uri.path)
  req['Content-type'] = 'application/json'
  req['authorization'] = "Bearer #{option[:token]}"

  res = http.start do |h|
    h.request(req)
  end

  JSON.parse(res.body)
end

main
