class NotValidReviewUrl < StandardError
  MESSAGE = 'Url is not a valid review Url'

  def http_status
    403
  end

  def code
    'not_valid_review_url'
  end

  def message
    MESSAGE
  end

  def to_hash
    {
      message: message,
      code: code
    }
  end
end
