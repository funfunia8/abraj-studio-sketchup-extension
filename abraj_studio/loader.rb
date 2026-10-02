# frozen_string_literal: true

module AbrajStudio
  module SketchUpIntegration
    class Loader
      def self.load_extension
        # Add the src directory to Ruby's load path
        extension_path = File.dirname(__FILE__)
        plugin_path = File.join(extension_path, 'src')
        $LOAD_PATH.unshift(plugin_path) unless $LOAD_PATH.include?(plugin_path)

        # Require all necessary modules
        require_relative '../../src/core/params'
        require_relative '../../src/core/cabinet_spec'
        require_relative '../../src/core/materials'
        require_relative '../../src/core/geometry_engine'
        require_relative '../../src/core/part_factory'
        require_relative '../../src/reports/detailed_cut_list'
        require_relative '../../src/reports/detailed_bom'
        require_relative '../../src/drawings/drawing_engine'
        require_relative '../../src/drawings/dxf_exporter'
        require_relative '../../src/sketchup/model_generator'
        require_relative '../../src/ui/cabinet_controller'
        require_relative '../../src/runtime/manufacturing_engine'
      end
    end
  end
end

# Load the extension when SketchUp starts
AbrajStudio::SketchUpIntegration::Loader.load_extension
