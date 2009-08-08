require 'rubygems'
#stolen from pandemic
module DLogReader
  class Processor
    def initialize(handler, num_threads = 10)
      read_from_parent, write_to_child = IO.pipe
      read_from_child, write_to_parent = IO.pipe
  
      @child_process_id = fork
      if @child_process_id
        # I'm the parent
        write_to_parent.close
        read_from_parent.close
        @out = write_to_child
        @in = read_from_child
        @max_queue_size = 100
        @counter = MutexCounter.new
        wait_for_responses
      else
        $dlog_logger.debug("Forked")
        # I'm the child
        write_to_child.close
        read_from_child.close
        @out = write_to_parent
        @in = read_from_parent
        @handler = handler
        @job_queue = Queue.new
        @response_queue = Queue.new
        wait_for_job_completion
        num_threads.times do
          create_thread
        end
        wait_for_jobs
      end
    end
  
    def num_jobs
      if parent?
        @counter.real_total
      end
    end
  
    def process(body)
      if parent?
        while(@counter.real_total > @max_queue_size)
          sleep(0.01)
        end
        body = (body.chomp + "\n")
        $dlog_logger.debug("Parent: writing #{body.inspect}")
        @out.write(body)
        @counter.inc
      else
        $dlog_logger.debug("Child Processing #{body}")
        return @handler.call(body)
      end
    end

    def close(status = 0)
      if parent? && child_alive?
        Process.detach(@child_process_id)
        @out.puts(status.to_s)
        @out.close
        @in.close
      else
        Process.exit!(status)
      end
    end

    def closed?
      !child_alive?
    end

    private

    def create_thread
      Thread.new do
        loop do
          line = @job_queue.pop
          process(line)
          $dlog_logger.debug("Child: Finished #{line.inspect}")
          @response_queue << :a
        end
      end
    end

    def wait_for_responses
      Thread.new do
        loop do
          ready, = IO.select([@in], nil, nil)
          if ready
            $dlog_logger.debug("Parent: Reading Response")  
            @in.readchar
            @counter.decr
          end
        end
      end
    end

    #child process
    def wait_for_jobs
      if child?
        while true
          $dlog_logger.debug("Child waiting")  
          ready, = IO.select([@in], nil, nil)
          if ready && !@in.eof?
            line = @in.gets
            $dlog_logger.debug("Child: #{line.inspect}")
            @job_queue << line
          else
            self.close(line.to_i)
            break  
          end
        end
      end
    end

    #child process
    def wait_for_job_completion
      if child?
        Thread.new do
          while true
            @response_queue.pop
            $dlog_logger.debug("Child: Writing To Parent")
            @out.write("|")
          end
        end
      end
    end


    def parent?
      !!@child_process_id
    end

    def child?
      !parent?
    end

    def child_alive?
      parent? && !@in.closed?
    end
  end
end