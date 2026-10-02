# frozen_string_literal: true

require_relative 'loader'

module AbrajStudio
  module SketchUpIntegration
    class CabinetSketchUpBridge
      def initialize
        @controller = nil
        @model = Sketchup.active_model
        @entities = @model.active_entities
      end

      def start
        create_menu
        create_toolbar
        setup_observer
      end

      private

      def create_menu
        menu = UI.menu('Plugins')
        cabinet_menu = menu.add_submenu('ABRAJ STUDIO')

        cabinet_menu.add_item('New Base Cabinet') { show_dialog }
        cabinet_menu.add_item('Update Cabinet') { update_cabinet_from_dialog }
        cabinet_menu.add_item('Export Cut List') { export_cut_list }
        cabinet_menu.add_item('Export BOM') { export_bom }
        cabinet_menu.add_item('Export DXF') { export_dxf }
      end

      def create_toolbar
        toolbar = UI::Toolbar.new('ABRAJ STUDIO')
        toolbar.show
      end

      def setup_observer
        @model.add_observer(CabinetModelObserver.new(self))
      end

      def show_dialog
        dialog = UI::HtmlDialog.new(
          title: 'ABRAJ STUDIO - Cabinet Designer',
          preferences_key: 'AbrajStudio_CabinetDesigner',
          width: 1000,
          height: 700,
          left: 100,
          top: 100,
          min_width: 800,
          min_height: 600
        )

        html_path = File.join(File.dirname(__FILE__), '../../src/ui/cabinet_dialog.html')
        dialog.set_file(html_path)

        dialog.add_action_callback('generateCabinet') do |action_context, data|
          handle_generate_cabinet(data, dialog)
        end

        dialog.add_action_callback('updateParameter') do |action_context, key, value|
          handle_update_parameter(key, value, dialog)
        end

        dialog.show
      end

      def handle_generate_cabinet(data, dialog)
        begin
          params = AbrajStudio::Core::Params.new(
            width: data['width'].to_f,
            height: data['height'].to_f,
            depth: data['depth'].to_f,
            thickness: data['thickness'].to_f,
            material: data['material'],
            shelf_count: data['shelf_count'].to_i,
            door_type: data['door_type'],
            hinge_type: data['hinge_type'],
            handle_type: data['handle_type'],
            edge_band: data['edge_band']
          )

          @controller = AbrajStudio::UI::CabinetController.new
          @controller.update_parameter('width', params.width)
          @controller.update_parameter('height', params.height)
          @controller.update_parameter('depth', params.depth)
          @controller.update_parameter('thickness', params.thickness)
          @controller.update_parameter('material', params.material)
          @controller.update_parameter('shelf_count', params.shelf_count)
          @controller.update_parameter('door_type', params.door_type)
          @controller.update_parameter('hinge_type', params.hinge_type)
          @controller.update_parameter('handle_type', params.handle_type)

          cabinet_spec = @controller.current_cabinet
          model_generator = AbrajStudio::SketchUp::ModelGenerator.new(cabinet_spec)
          model_data = model_generator.generate_3d_model_data

          create_cabinet_in_model(model_data)
          dialog.execute_script("updateOutput('Cabinet generated successfully');")
        rescue => e
          puts "Error: #{e.message}"
          dialog.execute_script("updateOutput('Error: #{e.message}');")
        end
      end

      def handle_update_parameter(key, value, dialog)
        return unless @controller

        @controller.update_parameter(key, value)
        cabinet_spec = @controller.current_cabinet

        model_generator = AbrajStudio::SketchUp::ModelGenerator.new(cabinet_spec)
        model_data = model_generator.generate_3d_model_data

        clear_model
        create_cabinet_in_model(model_data)

        cut_list = @controller.get_cut_list
        bom = @controller.get_bom

        dialog.execute_script("updateCutList(#{cut_list.to_json});")
        dialog.execute_script("updateBOM(#{bom.to_json});")
      end

      def create_cabinet_in_model(model_data)
        model_data[:entities].each do |entity|
          add_box_to_model(entity)
        end
      end

      def add_box_to_model(entity)
        pos = entity[:position]
        dims = entity[:dimensions]

        # Create a group for the component
        group = @entities.add_group
        group.name = entity[:name]

        # Add a box (rectangle extruded in Z)
        points = [
          [pos[:x], pos[:y], pos[:z]],
          [pos[:x] + dims[:width], pos[:y], pos[:z]],
          [pos[:x] + dims[:width], pos[:y] + dims[:height], pos[:z]],
          [pos[:x], pos[:y] + dims[:height], pos[:z]]
        ]

        face = group.entities.add_face(points)
        face.reverse! if face.normal.z < 0

        # Extrude to create depth
        face.pushpull(dims[:depth])
      end

      def clear_model
        @entities.each do |entity|
          @entities.erase_entities(entity) if entity.is_a?(Sketchup::Group)
        end
      end

      def export_cut_list
        return unless @controller

        cut_list = @controller.get_cut_list
        file_path = UI.save_panel('Save Cut List as CSV', '', 'cut_list.csv')
        return unless file_path

        File.open(file_path, 'w') do |file|
          file.puts 'Part Number,Name,Quantity,Width,Height,Material,Thickness,Edge Band'
          cut_list[:parts].each do |part|
            file.puts "#{part[:part_number]},#{part[:name]},#{part[:quantity]},#{part[:width]},#{part[:height]},#{part[:material]},#{part[:thickness]},#{part[:edge_band]}"
          end
        end

        UI.messagebox("Cut list exported to #{file_path}")
      end

      def export_bom
        return unless @controller

        bom = @controller.get_bom
        file_path = UI.save_panel('Save BOM as CSV', '', 'bom.csv')
        return unless file_path

        File.open(file_path, 'w') do |file|
          file.puts 'Type,Description,Quantity,Unit,Unit Cost,Total Cost'
          (bom[:materials] + bom[:hardware] + bom[:accessories]).each do |item|
            file.puts "#{item[:type] || item[:material]},#{item[:description]},#{item[:quantity]},#{item[:unit]},#{item[:unit_cost]},#{item[:total_cost]}"
          end
        end

        UI.messagebox("BOM exported to #{file_path}")
      end

      def export_dxf
        return unless @controller

        dxf_data = @controller.get_dxf_export
        file_path = UI.save_panel('Save DXF', '', 'cabinet.dxf')
        return unless file_path

        # Write DXF file (simplified format)
        File.open(file_path, 'w') do |file|
          file.puts 'DXF File Generated by ABRAJ STUDIO'
          dxf_data[:entities].each do |entity|
            file.puts entity.to_s
          end
        end

        UI.messagebox("DXF exported to #{file_path}")
      end
    end

    class CabinetModelObserver
      def initialize(bridge)
        @bridge = bridge
      end

      def onSaveModel(model)
        puts 'Model saved'
      end
    end
  end
end

# Start the extension when loaded
if defined?(Sketchup) && Sketchup.respond_to?(:active_model)
  bridge = AbrajStudio::SketchUpIntegration::CabinetSketchUpBridge.new
  bridge.start
end
