require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "LogChooser" do
  before(:all) do
    @chooser = LogChooser.new
  end

  describe "file_to_process" do
    it "should raise NotImplementedError" do
      lambda{ @chooser.file_to_process('dummy_file') }.should raise_error(NotImplementedError)
    end
  end
end