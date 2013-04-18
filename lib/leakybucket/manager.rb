require 'securerandom'

class Leakybucket::Manager

  attr_accessor :buckets, :default_options

  def initialize(default_options = {})
    self.default_options = default_options
    self.buckets = {}
  end

  def generate_key
    SecureRandom.uuid
  end

  def create_bucket(options = {})
    key = options['key'] || generate_key
    b = Leakybucket::Bucket.new(default_options.merge(options), key)
    buckets[key] = b
    b
  end

  def remove_bucket(key)
    buckets.delete(key)
  end
end