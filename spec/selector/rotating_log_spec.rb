require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'distributed_logreader/selector/rotating_log'
require 'fileutils'

describe "DLogReader::RotatingLog" do
  before(:all) do
    @chooser = DLogReader::RotatingLog.new
  end
    
  describe "file_to_process" do
    it "should pick the oldest file for logs in copytruncate format (file)" do
      @chooser.file_to_process(File.join(File.dirname(__FILE__), '..', 'fixtures', 'copytruncate', 'test')).should == File.join(File.dirname(__FILE__), '..', 'fixtures', 'copytruncate', 'test.1')      
    end
    
    it "should pick the oldest file in timestamp suffix log format (dirname)" do
      @chooser.file_to_process(File.join(File.dirname(__FILE__), '..', 'fixtures', 'logrotate')).should == File.join(File.dirname(__FILE__), '..', 'fixtures', 'logrotate', 'test-20090101')
    end
    
    it "should pick the oldest file ignoring symlinks pointing to files already in dir" do
      @chooser.file_to_process(File.join(File.dirname(__FILE__), '..', 'fixtures', 'symlink')).should == File.join(File.dirname(__FILE__), '..', 'fixtures', 'symlink', 'test')
    end
  end

end