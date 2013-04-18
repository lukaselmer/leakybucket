require 'leakybucket'

describe Leakybucket::Bucket do
  it 'creates a leaky bucket' do
    l = Leakybucket::Bucket.new(limit: 3)
    l.value.should eql(3)
  end

  it 'decrement a leaky bucket' do
    l = Leakybucket::Bucket.new(limit: 3)
    l.decrement
    l.value.should eql(2)
    l.decrement
    l.value.should eql(1)
    l.decrement
    l.value.should eql(0)
  end

  it 'should leak on -1' do
    l = Leakybucket::Bucket.new(limit: 3) # value is 3
    l.decrement # value is 2
    l.decrement # value is 1
    l.decrement # value is 0
    l.leaking?.should eql(false)
    l.decrement # value is -1
    l.leaking?.should eql(true)
  end

  it 'should reset to limit' do
    l = Leakybucket::Bucket.new(limit: 3) # value is 3
    l.decrement # value is 1
    l.reset
    l.value.should eql(3)
    l.limit = 10
    l.value.should eql(3)
    l.reset
    l.value.should eql(10)
  end
end
