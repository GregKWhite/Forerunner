class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ActiveSupport::Callbacks
  include Forerunner

  class << self
    %i(all before after around).each do |filter_type|
      define_method("list_#{filter_type}_actions") do
        retrieve_filters(_process_action_callbacks, filter_type).map(&:filter)
      end
    end

    private

    def retrieve_filters(possible_filters, filter_type)
      return possible_filters if filter_type == :all

      possible_filters.select do |filter_obj|
        filter_obj.kind == filter_type
      end
    end
  end
end
