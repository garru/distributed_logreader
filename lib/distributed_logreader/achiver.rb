# This abstract class defines the interface that handles log file archiving

module DLogReader
  class Archiver
    # archive file as you see fit
    def archive(filename)
      raise NotImplementedError.new("archive not implemented. Are you sure you created a conrete class?")
    end
  end
end