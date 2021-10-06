require './ruby_thread_pool_executor'

class AsyncAdapter
  def enqueue
    Scheduler.new.enqueue
  end

  def perform
    puts '---AsyncAdapter#perform---'
  end

  class JobWrapper
    def perform
      puts '---JobWrapper#perform---'
    end
  end

  class Scheduler
    def enqueue
      # job = JobWrapper.new
      job = AsyncAdapter.new
      RubyThreadPoolExecutor.new.post(job, &:perform)
    end
  end
end
