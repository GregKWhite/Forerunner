describe "Forerunner", type: :request do
  class TestController < ApplicationController
    include Forerunner

    precede_with :foo, only: %i(foo)
    def show
      head :ok
    end

    def foo; end
  end

  describe "#precede_with" do
    context "with valid arguments" do
      it "adds a before_filter for each of the specified methods for the next defined controller action" do
        expect(TestController.list_before_actions).to(include :foo)
      end
    end
  end
end
