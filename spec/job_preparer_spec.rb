# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Delayed::Backend::JobPreparer do
  describe '#extract_options' do
    args = {
      example: 'test1'
    }
    job_preparer = Delayed::Backend::JobPreparer.new(args)

    it { expect(job_preparer.instance_variable_get(:@options)).to eq(args) }
  end
end
