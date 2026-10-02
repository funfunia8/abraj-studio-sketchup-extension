#!/usr/bin/env ruby
# frozen_string_literal: true

# ABRAJ STUDIO - SketchUp Extension Loader
# This file registers the extension with SketchUp

require_relative 'main'

module AbrajStudio
  # Extension metadata
  EXTENSION_NAME = 'ABRAJ STUDIO'
  EXTENSION_VERSION = '1.0.0'
  EXTENSION_DESCRIPTION = 'Parametric furniture engineering extension for SketchUp'
  
  # Register the extension
  ext = SketchupExtension.new(
    EXTENSION_NAME,
    'abraj_studio/main'
  )
  
  ext.version = EXTENSION_VERSION
  ext.creator = 'ABRAJ STUDIO'
  ext.copyright = '2026 ABRAJ STUDIO'
  ext.description = EXTENSION_DESCRIPTION
  
  Sketchup.register_extension(ext, true)
end
