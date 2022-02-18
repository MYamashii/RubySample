source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.4'

gem 'debug'
gem 'rspec'

# Simplecov to generate coverage info
gem 'simplecov', require: false

# Simplecov-cobertura to generate an xml coverage file which can then be uploaded to Codecov
gem 'simplecov-cobertura'
