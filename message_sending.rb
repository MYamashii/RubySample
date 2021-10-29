require './base'
require './performable_method'
require './active_record'

module Delayed
  class DelayProxy
    def initialize(payload_class, target)
      @payload_class = payload_class
      @target = target
    end

    # rubocop:disable MethodMissing
    def method_missing(method, *args)
      # Delayed::Backend::ActiveRecord::Job.enqueue({:payload_object => @payload_class.new(@target, method.to_sym, args)})
      Delayed::Backend::Base::ClassMethods.enqueue({:payload_object => @payload_class.new(@target, method.to_sym, args)})
    end
  end

  class MessageSending
    def delay
      DelayProxy.new(Delayed::PerformableMethod, self)
    end
  end
end