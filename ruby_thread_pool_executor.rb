
class RubyThreadPoolExecutor
  def post(*args, &task)
    task.call(*args)
  end
end
