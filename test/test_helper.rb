# :stopdoc:

require 'simplecov'
SimpleCov.start

# require 'codeclimate-test-reporter'
# CodeClimate::TestReporter.start

require 'minitest/autorun'
require_relative '../lib/rhex'

# Ensure the image output directory exists
IMAGE_OUTPUT_DIRECTORY = 'tmp'
Dir.mkdir(IMAGE_OUTPUT_DIRECTORY) unless Dir.exist?(IMAGE_OUTPUT_DIRECTORY)
