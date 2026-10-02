# frozen_string_literal: true

module AbrajStudio
  module UI
    class CabinetController
      def initialize
        @current_params = Core::Params.new
        @current_cabinet = nil
        @observers = []
      end

      def update_parameter(key, value)
        case key
        when 'width'
          @current_params.width = value.to_f
        when 'height'
          @current_params.height = value.to_f
        when 'depth'
          @current_params.depth = value.to_f
        when 'thickness'
          @current_params.thickness = value.to_f
        when 'material'
          @current_params.material = value
        when 'shelf_count'
          @current_params.shelf_count = value.to_i
        when 'door_type'
          @current_params.door_type = value
        when 'hinge_type'
          @current_params.hinge_type = value
        when 'handle_type'
          @current_params.handle_type = value
        end

        refresh_model
        notify_observers
      end

      def refresh_model
        @current_cabinet = Core::CabinetSpec.new(@current_params)
      end

      def get_cut_list
        Reports::DetailedCutList.new(@current_cabinet).generate if @current_cabinet
      end

      def get_bom
        Reports::DetailedBom.new(@current_cabinet).generate if @current_cabinet
      end

      def get_drawings
        Drawings::DrawingEngine.new(@current_cabinet).generate_front_elevation if @current_cabinet
      end

      def get_dxf_export
        Drawings::DxfExporter.new(@current_cabinet).export_parts_to_dxf if @current_cabinet
      end

      def register_observer(observer)
        @observers << observer
      end

      def notify_observers
        @observers.each { |observer| observer.update(@current_cabinet) }
      end

      def current_cabinet
        @current_cabinet
      end
    end
  end
end
