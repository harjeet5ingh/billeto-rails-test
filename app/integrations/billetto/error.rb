module Billetto
  # Base class for anything that goes wrong talking to Billetto, so callers
  # never have to rescue Faraday or JSON errors directly.
  class Error < StandardError; end
end
