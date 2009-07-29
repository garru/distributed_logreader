require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DLogReader::LogArchiver" do
  before(:all) do
    @archiver = DLogReader::Archiver.new
  end

  describe "archive" do
    it "should raise NotImplementedError" do
      lambda{ @archiver.archive('dummy_file') }.should raise_error(NotImplementedError)
    end
  end
end