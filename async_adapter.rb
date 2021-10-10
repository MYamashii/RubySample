require './ruby_thread_pool_executor'

class AsyncAdapter
  def enqueue
    Scheduler.new.enqueue
  end

  def perform
    puts '---AsyncAdapter#perform---'
  end

  class JobWrapper
    def perform(hoge)
      puts '---JobWrapper#perform---'
      puts hoge.inspect
    end
  end

  class Scheduler
    def enqueue
      job = JobWrapper.new
      arguments = 'do something'
      # job = AsyncAdapter.new
      RubyThreadPoolExecutor.new.post(job, arguments, &:perform)
    end
  end
end
