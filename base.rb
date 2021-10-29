require './job_preparer'
module Delayed
  module Backend
    module Base

      module ClassMethods
        # Add a job to the queue
        def self.enqueue(*args)
          
          Delayed::Backend::JobPreparer.new(*args).prepare
          # enqueue_job(job_options)
        end
      end

      def payload_object=(object)
        @payload_object = object
        puts '---payload_object is called---'
        # self.handler = object.to_yaml
      end
    end
  end
end