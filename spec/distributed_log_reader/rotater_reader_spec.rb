require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fileutils'

describe "DLogReader::RotaterLogreader" do
  before(:all) do
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file'), File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file2'))
    @file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file2')
    @base_backup_dir = File.join(File.dirname(__FILE__), '..', 'fixtures', 'temp_backup_dir')
    time = Time.now
    @backup_dir = File.join([@base_backup_dir, time.year.to_s, time.month.to_s, time.day.to_s])
    @logreader = DLogReader::RotaterReader.new(@file_path, @base_backup_dir, lambda{|x| puts x})
  end

  describe "process" do
    it 'should' do 
      @logreader.process
      File.exist?(@backup_dir).should == true
      File.exist?(@file_path).should == false
    end
  end
  
  after(:all) do
    FileUtils.rm_r(@base_backup_dir)
    FileUtils.rm_r(@logreader.log_reader.statefile)
  end
end
