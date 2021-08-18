module Delayed
  class Worker 
    DEFAULT_DELAY_JOBS       = true

    attr_accessor :delay_jobs

    def self.reset
      delay_jobs        = DEFAULT_DELAY_JOBS
      puts '---reset---'
    end

    def self.delay_job?
      puts '---delay_job?---'
    end
  end
end

Delayed::Worker.reset