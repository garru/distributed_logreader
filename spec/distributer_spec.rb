require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'distributed_logreader/distributer'

describe "DLogReader::Distributer" do
  before(:all) do
    @distributer = DLogReader::Distributer.new(lambda{|x| x})
  end
  
  describe "process" do
    it "should raise NotImplementedError" do
    end
  end
end