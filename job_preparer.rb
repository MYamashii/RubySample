module Delayed
  module Backend
    class JobPreparer
      attr_reader :options, :args

      def initialize(*args)
        @options = extract_options(args).dup
        @args = args
      end

      def extract_options(array)
        # if array.last.is_a?(Hash) && array.last.extractable_options?
        if array.last.is_a?(Hash)
          array.pop
        else
          {}
        end
      end

      def prepare
        set_payload
        puts '---prepare is called---'
        # set_queue_name
        # set_priority
        # handle_deprecation
        # options
      end

    private

      def set_payload
        options[:payload_object] ||= args.shift
      end
    end
  end
end