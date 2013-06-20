require 'coveralls'
Coveralls.wear!

require 'leakybucket'

describe Leakybucket::Bucket do
  it 'should create buckets' do
    m = Leakybucket::Manager.new
    b1 = m.create_bucket(limit: 5)
    b1.limit.should eql(5)
    m.buckets.size.should eql(1)
    m.buckets[b1.key].should eql(b1)

    b2 = m.create_bucket(limit: 3)
    b2.limit.should eql(3)
    m.buckets.size.should eql(2)
    b1.key.should_not eql(b2.key)
    m.buckets[b2.key].should eql(b2)
    m.buckets[b2.key].should_not eql(b1)
  end

  it 'should remove buckets' do
    m = Leakybucket::Manager.new
    b1 = m.create_bucket(limit: 5)
    m.buckets.size.should eql(1)
    b2 = m.remove_bucket(b1.key)
    m.buckets.size.should eql(0)
    b1.should eq(b2)
  end
end
