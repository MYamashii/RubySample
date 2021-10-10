
class RubyThreadPoolExecutor
  def post(*args, args2, &task)
    task.call(*args, args2)
  end
end
