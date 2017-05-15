module Forerunner
  class Analyzer
    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end
  end
end
