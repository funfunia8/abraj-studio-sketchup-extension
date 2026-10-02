#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

module AbrajStudio
  class Extension
    def initialize
      @model = Sketchup.active_model
      @entities = @model.active_entities
      @dialog = nil
    end

    def start
      puts 'ABRAJ STUDIO Extension Started'
      create_menu
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

      html_file = File.expand_path(File.join(File.dirname(__FILE__), 'ui.html'))
      @dialog.set_file(html_file)

      @dialog.add_action_callback('generateCabinet') do |_context, data|
        begin
          parsed = JSON.parse(data)
          handle_generate_cabinet(parsed)
        rescue => e
          puts "JSON parse error: #{e.message}"
          @dialog.execute_script("showStatus('Error: #{e.message}', 'error');")
        end
      end

      @dialog.show
    end

    def handle_generate_cabinet(data)
      width_mm = data['width'].to_f
      height_mm = data['height'].to_f
      depth_mm = data['depth'].to_f
      thickness_mm = data['thickness'].to_f
      shelf_count = data['shelfCount'].to_i

      raise 'Invalid dimensions' if width_mm <= 0 || height_mm <= 0 || depth_mm <= 0

      clear_cabinet
      create_cabinet_geometry(width_mm, height_mm, depth_mm, thickness_mm, shelf_count)

      @dialog.execute_script("showStatus('Cabinet created successfully!', 'success');")
      puts "Cabinet created: #{width_mm}x#{height_mm}x#{depth_mm}mm"
    end

    def create_cabinet_geometry(width_mm, height_mm, depth_mm, thickness_mm, shelf_count)
      width = width_mm / 25.4
      height = height_mm / 25.4
      depth = depth_mm / 25.4
      thickness = thickness_mm / 25.4

      create_box(0, 0, 0, thickness, height, depth, 'Left Side')
      create_box(width - thickness, 0, 0, thickness, height, depth, 'Right Side')
      create_box(thickness, height - thickness, 0, width - (2 * thickness), thickness, depth, 'Top Panel')
      create_box(thickness, 0, 0, width - (2 * thickness), thickness, depth, 'Bottom Panel')

      if shelf_count > 0
        shelf_positions = shelf_positions_for(height, shelf_count)
        shelf_positions.each do |shelf_y|
          create_box(thickness, shelf_y, 0, width - (2 * thickness), thickness, depth, 'Shelf')
        end
      end

      door_width = width - (2 * thickness) - 0.15
      door_height = height - (2 * thickness)
      create_box(thickness + 0.05, thickness, depth + 0.1, door_width, door_height, 0.12, 'Door')

      create_handle(width / 2, height / 2, depth + 0.2)
    end

    def shelf_positions_for(height, count)
      spacing = height - 0.2
      if count == 1
        [height / 2]
      else
        step = spacing / (count + 1)
        positions = []
        (1..count).each do |i|
          positions << (step * i)
        end
        positions
      end
    end

    def create_box(x, y, z, width, height, depth, name)
      pt1 = Geom::Point3d.new(x, y, z)
      pt2 = Geom::Point3d.new(x + width, y, z)
      pt3 = Geom::Point3d.new(x + width, y + height, z)
      pt4 = Geom::Point3d.new(x, y + height, z)

      face = @entities.add_face(pt1, pt2, pt3, pt4)
      face.reverse! if face.normal.z < 0
      face.pushpull(depth)

      group = @entities.add_group
      group.name = name
    end

    def create_handle(x, y, z)
      handle_group = @entities.add_group
      handle_group.name = 'Handle'
      handle_points = [
        Geom::Point3d.new(x - 0.4, y, z),
        Geom::Point3d.new(x + 0.4, y, z),
        Geom::Point3d.new(x + 0.4, y + 0.06, z),
        Geom::Point3d.new(x - 0.4, y + 0.06, z)
      ]
      face = handle_group.entities.add_face(handle_points)
      face.pushpull(0.04)
    end

    def clear_cabinet
      @entities.grep(Sketchup::Group).each do |group|
        @entities.erase_entities(group)
      end
    end

    def show_about
      UI.messagebox(
        "ABRAJ STUDIO v1.0\n\nParametric Furniture Engineering Extension for SketchUp",
        MB_OK,
        'About ABRAJ STUDIO'
      )
    end
  end

  if defined?(Sketchup) && Sketchup.respond_to?(:active_model)
    extension = Extension.new
    extension.start
  end
end
