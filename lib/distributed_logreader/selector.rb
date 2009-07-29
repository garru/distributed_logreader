module DLogReader
  # This abstract class defines the interface to decide which log 
  # file to read. The identity strategy is the simplist, to return the file 
  # inputed. However, to handle rotating log files, we'll need some more complex 
  # strategies.
  class Selector
    # determines the file to process from file path input
    def file_to_process(file_or_dir)
      raise NotImplementedError.new, "file_to_process not implemented. Are you sure you created a conrete class?"
    end
  end
end