module Billetto
  # The request itself failed - network error, timeout, non-2xx response.
  class RequestError < Error; end
end
