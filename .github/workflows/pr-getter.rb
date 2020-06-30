#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

def main
  github_token = ENV.fetch('TOKEN')
  url = ENV.fetch('PR_URL')

  res = fetch(url, { token: github_token })
  head = res['head']

  set_env(ref: head['ref'], sha: head['sha'])
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

def set_env(ref:, sha:)
  system! "echo ::set-env name=branch_name::#{ref}"
  system! "echo ::set-env name=sha::#{sha}"
end

main
