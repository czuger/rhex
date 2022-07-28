# frozen_string_literal: true

require 'json'

module Rhex
  class ImageConfigs
    CONFIG_PATTERN = '*_config.yml'
    private_constant :CONFIG_PATTERN

    class << self
      def load!
        path = File.join(Rhex.configuration.image_configs_path, CONFIG_PATTERN)
        Dir.glob(path).each do |file_path|
          load_file!(file_path)
        end
      end

      private

      def load_file!(file_path)
        extname = File.extname(file_path)
        filename = File.basename(file_path, extname)
        config = JSON.parse!(
          YAML.safe_load(File.read(file_path)).to_json,
          object_class: OpenStruct
        )

        define_singleton_method(filename) do
          config
        end
      end
    end
  end
end
