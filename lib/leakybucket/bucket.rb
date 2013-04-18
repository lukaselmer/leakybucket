class Leakybucket::Bucket

  attr_accessor :limit, :value, :leaking_callback, :key

  def initialize(options = {}, key = '')
    self.limit = default_options.merge(options)[:limit].to_i
    self.value = self.limit
    self.key = key
  end

  def default_options
    {limit: 3}
  end

  def decrement
    self.value -= 1
    leaking! if leaking?
  end

  def increment
    return if value >= limit
    self.value += 1
  end

  def leaking?
    value < 0
  end

  def leaking!
    leaking_callback.(value) if leaking_callback.respond_to?(:call)
  end

  def reset
    self.value = limit
  end
end