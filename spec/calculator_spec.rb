# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Calculator do
  describe '#sum' do
    it { expect(described_class.new.sum(1, 2)).to eq(3) }
  end

  describe '#multipy' do
    it { expect(described_class.new.multipy(1, 2)).to eq(2) }
  end
end
