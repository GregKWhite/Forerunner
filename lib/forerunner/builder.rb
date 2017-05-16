module Forerunner
  class Builder
    attr_reader :controller
    attr_accessor :actions

    delegate :_insert_callbacks, :set_callback, to: :controller

    def initialize(controller)
      @controller = controller
      @actions = []
    end

    def enqueue_action(action_type, action_params, block)
      actions << parse_action_data(action_type, action_params, block)
    end

    def process_actions(target_action)
      actions.each do |action_data|
        insert_new_filter(target_action, action_data)
      end

      actions.clear
    end

    private

    def insert_new_filter(target_action, action_data)
      action_data.limit_to_action(target_action)

      _insert_callbacks(action_data.params, action_data.block) do |name, options|
        set_callback(:process_action, action_data.action_type, name, options)
      end
    end

    def parse_action_data(action_type, action_params, block)
      ActionData.new(
        action_type: action_type,
        action_data: action_params,
        block: block
      )
    end
  end
end
