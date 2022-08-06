class NotValidLendingTreeUrl < StandardError
  MESSAGE = 'Url is not a valid LendingTree Url'
  def http_status
    403
  end

  def code
    'not_valid_lending_tree_url'
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
