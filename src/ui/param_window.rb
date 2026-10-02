# frozen_string_literal: true

module AbrajStudio
  module UI
    class ParamWindow
      def initialize
        @data = {}
      end

      def render
        {
          title: 'ABRAJ STUDIO',
          sections: [
            { name: 'Cabinet Dimensions', fields: %w[width height depth thickness] },
            { name: 'Materials', fields: %w[material door_type hinge_type handle_type] },
            { name: 'Reports', fields: %w[cut_list bom pricing] }
          ]
        }
      end
    end
  end
end
