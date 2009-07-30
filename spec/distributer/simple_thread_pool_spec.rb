require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'distributed_logreader/distributer/simple_thread_pool'

describe "DLogReader::SimpleThreadPool" do
  before(:all) do
    @thread_pool = DLogReader::SimpleThreadPool.new(lambda{|x| x}, 10)
  end
  
  describe "process" do
    it 'should process with lots of threads' do
      100.times do |x|
        @thread_pool.process(x.to_s)
      end
      @thread_pool.join
    end
  end
end