class LogChooser
  def file_to_process(file_or_dir)
    raise NotImplementedError.new, "file_to_process not implemented. Are you sure you created a conrete class?"
  end
end