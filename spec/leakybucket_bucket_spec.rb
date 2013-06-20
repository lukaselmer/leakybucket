require 'coveralls'
Coveralls.wear!

require 'leakybucket'

describe Leakybucket::Bucket do
  it 'should creates leaky bucket' do
    l1 = Leakybucket::Bucket.new(limit: 3)
    l1.value.should eql(3)
    l2 = Leakybucket::Bucket.new(limit: 5)
    l2.value.should eql(5)
    l3 = Leakybucket::Bucket.new
    l3.value.should eql(3)
  end

  it 'should decrement leaky bucket' do
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

  it 'should call leaking method when leaking on decrement' do
    l = Leakybucket::Bucket.new(limit: 1)
    out = ''
    l.leaking_callback = ->(value){out = "leaking with value #{value}"}
    out.should eql('')
    l.decrement
    out.should eql('')
    l.decrement
    out.should eql('leaking with value -1')
    l.decrement
    out.should eql('leaking with value -2')
  end
end

