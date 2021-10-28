require './base'
module Delayed
  module Backend
    module ActiveRecord
      class Job
        include Delayed::Backend::Base
      end
    end
  end
end