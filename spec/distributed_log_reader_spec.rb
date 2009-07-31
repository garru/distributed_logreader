require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fileutils'

describe "DLogReader::DistributedLogreader" do
  before(:all) do
    FileUtils.cp(File.join(File.dirname(__FILE__), 'fixtures', 'test_file'), File.join(File.dirname(__FILE__), 'fixtures', 'test_file2'))
    @file_path = File.join(File.dirname(__FILE__), 'fixtures', 'test_file2')
    @logreader = DLogReader::DistributedLogReader.new(@file_path, lambda{|x| puts x})
  end

  describe "process" do
    it 'should' do 
      @logreader.process
    end
  end
  
  after(:all) do
    FileUtils.rm_r(@logreader.log_reader.statefile)
  end
end
