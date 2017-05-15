module Forerunner
  class ActionData
    class MissingActionNameError < StandardError
      def to_s
        "Forerunner filter must have at least one action name"
      end
    end
  end
end
