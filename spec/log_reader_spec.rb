require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'distributed_logreader/log_reader'
require 'fileutils'

describe "DLogReader::LogReader" do
  before(:all) do
    test_file = File.join(File.dirname(__FILE__), 'fixtures', 'test_file')
    FileUtils.mkdir(File.join(File.dirname(__FILE__), 'fixtures', 'logreading'))
    @test_cp = File.join(File.dirname(__FILE__), 'fixtures', 'logreading', 'test')
    FileUtils.cp(test_file, @test_cp)
    test_fh = File.open(test_file)
    
    @reader = DLogReader::LogReader.new(@test_cp) do |line|
      unless test_fh.readline == line
        raise RuntimeError.new, 'you messed up bud'
      end
    end
    @test_line = "this is an added line.  this should be read first\n"
    @state_writer = DLogReader::LogReader.new(@test_cp){|line| line;}
    @state_reader = DLogReader::LogReader.new(@test_cp) do |line|
      unless line == @test_line
        raise RuntimeError.new, 'you messed up worse'
      end
    end
  end
  
  describe "run" do
    it 'should read log files' do
      lambda{@reader.run}.should_not raise_error
    end
    
    it 'should resume from last access' do
      #lets read to the end of file and write state
      lambda{@state_writer.run}.should_not raise_error
      fh = File.open(@test_cp, 'a')
      fh.write(@test_line)
      fh.close
      lambda{@state_reader.run}.should_not raise_error
    end
    
    it 'should detect if log is different from last and to start from beg of file' do
      lambda{@state_writer.run}.should_not raise_error
      fh = File.open(@test_cp, 'w')
      fh.write(@test_line)
      fh.close
      lambda{@state_reader.run}.should_not raise_error
      fh = File.open(@test_cp, 'w')
      fh.write('')
      fh.close
      lambda{@state_reader.run}.should_not raise_error
    end
  end
  
  after(:all) do
    FileUtils.rm_r(File.dirname(@test_cp))
  end 
end