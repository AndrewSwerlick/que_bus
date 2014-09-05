require_relative '../../spec_helper'

describe Bus do
  describe "when we create a new bus" do
    let(:bus) {Bus.new}

    describe "and subscribe the bus" do
      before do
        @id = bus.subscribe
      end

      it "gives us a subscription id" do
        @id.wont_be_nil
      end

      it "shows us as one of the subscribers" do
        bus.subscribers.must_include @id
      end
    end

    describe "when we subscribe to the bus with our own id" do
      before do
        @id = bus.subscribe("test")
      end

      it "gives us the same id back" do
        @id.must_equal "test"
      end

      it "shows us as one of the subscribes using that id" do
        bus.subscribers.must_include @id
      end
    end


    it "allows us to subscribe to all channels on the bus" do
      bus.subscribe
    end

    it "allows us to publish to a channel" do
      bus.publish("foo", {test: "test"})
    end

    it "allows us to publish to all listeners on the bus" do
      bus.publish({test:"test"})
    end
  end
end
