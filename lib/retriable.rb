module Retriable
  def do_retriable
    yield
  rescue Twitter::Error::TooManyRequests => e
    logger.info "sleep #{e.rate_limit.reset_in + 1} sec"
    sleep e.rate_limit.reset_in + 1
    retry
  end
end
