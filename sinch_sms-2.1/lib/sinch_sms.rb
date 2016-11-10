require "base64"
require "openssl"
require "time"
require "net/http"
require "uri"
require "json"

class SinchSms
#   def self.send(key, secret, message, to)
#     body = "{\"message\":\"#{message}\"}"
#     timestamp = Time.now.iso8601
#     authorization = auth(key, secret, "/v1/sms/#{to}", "POST", timestamp,  body)

#     uri = URI.parse("https://messagingApi.sinch.com/v1/sms/" + to)
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true
#     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#     headers = {"content-type" => "application/json", "x-timestamp" => timestamp, "authorization" => authorization}
#     request = Net::HTTP::Post.new(uri.request_uri)
#     request.initialize_http_header(headers)
#     request.body = body
#     return JSON.parse(http.request(request).body)
#   end
  
  def self.send(key, secret, message, to, from)
    body = "{\"message\":\"#{message}\", \"from\":\"#{from}\"}"
    timestamp = Time.now.iso8601
    authorization = auth(key, secret, "/v1/sms/#{to}", "POST", timestamp,  body)

    uri = URI.parse("https://messagingApi.sinch.com/v1/sms/" + to)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {"content-type" => "application/json", "x-timestamp" => timestamp, "authorization" => authorization}
    request = Net::HTTP::Post.new(uri.request_uri)
    request.initialize_http_header(headers)
    request.body = body
    return JSON.parse(http.request(request).body)
  end

  def self.status(key, secret, id)
    timestamp = Time.now.iso8601
    authorization = self.auth(key, secret, "/v1/message/status/#{id}", "GET", timestamp)

    uri = URI.parse("https://messagingApi.sinch.com/v1/message/status/" + id)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {"content-type" => "application/json", "x-timestamp" => timestamp, "authorization" => authorization}
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header(headers)

    return JSON.parse(http.request(request).body)
  end

  private
  def self.auth(key, secret, path, http_verb, timestamp, body=nil)
    scheme = "Application"
    content_type = "application/json"
    digest = OpenSSL::Digest.new('sha256')
    canonicalized_headers = "x-timestamp:" + timestamp
    
    if body
      content_md5 = Base64.encode64(Digest::MD5.digest(body.encode("UTF-8"))).strip
    else 
      content_md5 = ""
    end

    string_to_sign = http_verb + "\n" + content_md5 + "\n" + content_type + "\n" + canonicalized_headers + "\n" + path        
    signature = Base64.encode64(OpenSSL::HMAC.digest(digest, Base64.decode64(secret), string_to_sign.encode("UTF-8"))).strip

    return "Application #{key}:#{signature}"
  end
end





























