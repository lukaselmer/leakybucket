class Leakybucket::Bucket

  attr_accessor :limit
  attr_accessor :value

  def initialize(options = {})
    self.limit = options[:limit] || default_options[:limit]
    self.value = limit
  end

  def default_options
    {limit: 3}
  end

  def decrement
    self.value -= 1
  end

  def increment
    return if value >= limit
    self.value += 1
  end

  def leaking?
    value < 0
  end

  def reset
    self.value = limit
  end
end