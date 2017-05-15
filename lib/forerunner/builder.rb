module Forerunner
  class Builder
    VALID_ACTION_TYPES = %i(before around after)

    attr_reader :controller
    attr_accessor :before_actions

    delegate :_insert_callbacks, :set_callback, to: :controller

    def initialize(controller)
      @controller = controller
      @before_actions = []
    end

    def enqueue_action(action_type, action_params, block)
      validate_action_type!(action_type)

      queue_for(action_type) << parse_action_data(action_params, block)
    end

    def process_actions(target_action)
      before_actions.each do |action_data|
        insert_new_filter(:before, target_action, action_data)
      end

      before_actions.clear
    end

    private

    def insert_new_filter(action_type, target_action, action_data)
      action_data.limit_to_action(target_action)

      _insert_callbacks(action_data.params, action_data.block) do |name, options|
        set_callback(:process_action, action_type, name, options)
      end
    end

    def queue_for(action_type)
      case action_type
      when :before then before_actions
      end
    end

    def parse_action_data(action_params, block)
      ActionData.new(
        action_data: action_params,
        block: block
      )
    end

    def validate_action_type!(action_type)
      return if VALID_ACTION_TYPES.include?(action_type)

      raise InvalidActionTypeError, action_type
    end
  end
end
