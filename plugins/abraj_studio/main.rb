#!/usr/bin/env ruby
# frozen_string_literal: true

# ABRAJ STUDIO - Main Extension Module
# This file contains the core extension logic

module AbrajStudio
  class Extension
    def initialize
      @model = Sketchup.active_model
      @entities = @model.active_entities
    end

    def start
      puts 'ABRAJ STUDIO Extension Started'
      create_menu
      create_cabinet_dialog
    end

    private

    def create_menu
      plugins_menu = UI.menu('Plugins')
      abraj_menu = plugins_menu.add_submenu('ABRAJ STUDIO')
      
      abraj_menu.add_item('New Base Cabinet') { show_cabinet_dialog }
      abraj_menu.add_item('About') { show_about }
    end

    def show_cabinet_dialog
      @dialog = UI::HtmlDialog.new(
        title: 'ABRAJ STUDIO - Cabinet Designer',
        width: 1000,
        height: 700,
        left: 100,
        top: 100
      )

      html_file = File.join(File.dirname(__FILE__), 'ui.html')
      @dialog.set_file(html_file)

      @dialog.add_action_callback('generateCabinet') do |_action_context, data|
        handle_generate_cabinet(data)
      end

      @dialog.show
    end

    def handle_generate_cabinet(data)
      begin
        width = data['width'].to_f
        height = data['height'].to_f
        depth = data['depth'].to_f
        
        # Validate dimensions
        raise 'Invalid dimensions' if width <= 0 || height <= 0 || depth <= 0

        # Clear previous geometry
        clear_cabinet

        # Create cabinet geometry
        create_cabinet_geometry(width, height, depth)

        @dialog.execute_script("showStatus('Cabinet created successfully');")
        puts "Cabinet created: #{width}x#{height}x#{depth}mm"
      rescue => e
        @dialog.execute_script("showStatus('Error: #{e.message}');")
        puts "Error: #{e.message}"
      end
    end

    def create_cabinet_geometry(width, height, depth)
      # Create cabinet shell
      thickness = 18 # mm
      
      # Left side panel
      create_box(
        0, 0, 0,
        thickness, height, depth,
        'Left Side'
      )

      # Right side panel
      create_box(
        width - thickness, 0, 0,
        thickness, height, depth,
        'Right Side'
      )

      # Top panel
      create_box(
        thickness, height - thickness, 0,
        width - (2 * thickness), thickness, depth,
        'Top Panel'
      )

      # Bottom panel
      create_box(
        thickness, 0, 0,
        width - (2 * thickness), thickness, depth,
        'Bottom Panel'
      )

      # Door
      door_width = width - (2 * thickness) - 2
      door_height = height - (2 * thickness)
      create_box(
        thickness + 1, thickness, depth + 2,
        door_width, door_height, thickness,
        'Door'
      )
    end

    def create_box(x, y, z, width, height, depth, name)
      # Create points for the box
      pt1 = Geom::Point3d.new(x, y, z)
      pt2 = Geom::Point3d.new(x + width, y, z)
      pt3 = Geom::Point3d.new(x + width, y + height, z)
      pt4 = Geom::Point3d.new(x, y + height, z)

      # Create face and extrude
      face = @entities.add_face(pt1, pt2, pt3, pt4)
      face.reverse! if face.normal.z < 0
      face.pushpull(depth)

      # Add to group
      group = @entities.add_group
      group.name = name
    end

    def clear_cabinet
      @entities.each do |entity|
        @entities.erase_entities(entity) if entity.is_a?(Sketchup::Group)
      end
    end

    def show_about
      UI.messagebox(
        "ABRAJ STUDIO v1.0\n\n" \
        "Parametric Furniture Engineering Extension for SketchUp\n\n" \
        "Transform your furniture designs into production-ready manufacturing data.",
        MB_OK,
        'About ABRAJ STUDIO'
      )
    end

    def create_cabinet_dialog
      # Initialize on first load
    end
  end

  # Start the extension
  if defined?(Sketchup) && Sketchup.respond_to?(:active_model)
    extension = Extension.new
    extension.start
  end
end
