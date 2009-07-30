module DLogReader
  class Distributer
    attr_accessor :worker

    def initialize(worker)
      self.worker = worker
    end
    
    def process(line)
      worker.call(line)
    end
  end
end