# frozen_string_literal: true

require 'sketchup.rb'
require 'extensions.rb'

module AbrajStudio
  unless file_loaded?(__FILE__)
    file_loaded(__FILE__)

    PLUGIN_NAME = 'ABRAJ STUDIO'
    PLUGIN_VERSION = '1.0'
    PLUGIN_ID = 'com.abrajstudio.sketchup'

    ext = SketchupExtension.new(PLUGIN_NAME, 'abraj_studio/main')
    ext.version = PLUGIN_VERSION
    ext.creator = 'ABRAJ STUDIO'
    ext.copyright = '2026'
    ext.description = 'Parametric furniture engineering extension for SketchUp'

    Sketchup.register_extension(ext, true)
  end
end
