#!/usr/bin/env ruby

require 'net/http'
require 'uri'

def main
  github_token = ENV.fetch('TOKEN')
  url = ENV.fetch('PR_URL', { token: github_token })

  res = fetch(url)
  puts res['head']
end

def fetch(url, option)
  uri = URI.parse(url)

  req = Net::HTTP::Get.new(url.path)
  req['Content-type'] = 'application/json'
  req['authorization'] = "Bearer #{option[:token]}"

  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end

  JSON.parse(res.body)
end

main
