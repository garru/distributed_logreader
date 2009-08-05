require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fileutils'

describe "DLogReader::RotaterLogreader" do
  before(:all) do
    @file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'virality_metrics')
    @logreader = DLogReader::ScribeReader.new(@file_path, 'tmp', lambda{|x| puts x})
  end

  describe "current" do
    it 'should say that the log_file is the currently rotated one' do 
      @logreader.current?.should == true
    end
  end  
end
