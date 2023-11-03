# frozen_string_literal: true

require 'zeitwerk'
require 'ostruct'
require 'yaml'
require 'delegate'
require 'forwardable'
require 'json'
require 'rmagick'

Zeitwerk::Loader.for_gem.tap do |loader|
  loader.enable_reloading
  loader.setup
end

module Rhex
  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end
end
