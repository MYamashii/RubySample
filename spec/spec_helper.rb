# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

require 'simplecov-cobertura'
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'job_preparer'
