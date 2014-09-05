require_relative '../../spec_helper'

describe Bus do
  describe "when we create a new bus" do
    let(:bus) {Bus.new}

    it "allows us to subscribe to a channel" do
      bus.subscribe("foo")
    end

    it "allows us to publish to a channel" do
      bus.publish("foo", {test: "test"})
    end
  end
end
