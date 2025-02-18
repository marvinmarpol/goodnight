class Rack::Attack
  # limit requests to 60 per minute by ip address
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    req.ip
  end

  # log blocked requests for debugging
  self.throttled_response = lambda do |env|
    Rails.logger.warn "throttle limit reached for: #{env['REMOTE_ADDR']}"
    [ 429, { "content-type" => "application/json" }, [ { error: "rate limit exceeded. try again later." }.to_json ] ]
  end
end
