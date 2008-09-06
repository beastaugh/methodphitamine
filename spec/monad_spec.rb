require 'ostruct'
require File.dirname(__FILE__) + "/../lib/methodphitamine.rb"

describe "The maybe() method" do
  it "should return nil when a link in a chain of methods returns nil before all methods are done executing" do
    hash = {'mary' => {}}
    long_search = hash.maybe &it['mary']['had']['a']['little']['lamb'].fleece.color == :white_as_snow
    long_search.should eql(nil)
  end
  
  it "should return the last return value in a chain of methods if all returned non-nil values" do
    test = "foo bar"
    test.maybe &it.reverse.upcase.chop.reverse
    test.should be_kind_of(String)
  end
  
  it "should also break the method chain when a link in the chain returns false" do
    one   = OpenStruct.new
    two   = OpenStruct.new
    
    one.foo = two
    two.bar = false
    
    value = one.maybe &it.two.bar.upcase.reverse
    value.should eql(nil)
  end
  
end
