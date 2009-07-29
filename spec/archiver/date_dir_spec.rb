require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'distributed_logreader/archiver/date_dir'
require 'fileutils'

describe "DLogReader::DateDir" do
  before(:all) do
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file'), File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file2'))
    @file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_file2')
    @base_backup_dir = File.join(File.dirname(__FILE__), '..', 'fixtures', 'temp_backup_dir')
    time = Time.now
    @backup_dir = File.join([@base_backup_dir, time.year.to_s, time.month.to_s, time.day.to_s])
    @archiver = DLogReader::DateDir.new(@base_backup_dir)
  end
    
  describe "backup" do
    it "should move file into Y/M/D backup directory" do
      @archiver.backup(@file_path)
      File.exist?(@backup_dir).should == true
    end
  end
  
  after(:all) do
    FileUtils.rm_r(@base_backup_dir)
  end
end