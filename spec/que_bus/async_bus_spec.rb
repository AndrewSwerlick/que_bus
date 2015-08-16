require 'async_spec_helper'

describe QueBus::Bus do
  describe "when we create a new bus" do
    let(:bus) {QueBus::Bus.new }

    describe "when we have a subscriber and we publish a message" do
      before do
        state = {}
        @state = state
        bus.subscribe("test") do
          state[:event_recieved] = true
        end
        bus.publish("test")
      end

      it "recieves the message" do
        eventually do
          @state[:event_recieved].must_equal true
        end
      end
    end

    describe "when we have a subscriber in the database that is not currently connected
      and we publish a message and then connect the subscriber" do
      before do
        state = {}
        @state = state
        QueBus::Subscriber.create(subscriber_id: "test", job_class: "QueBus::Jobs::Jobtest")
        bus.publish("reconnect_test")
        bus.subscribe("test") do
          state[:event_recieved] = true
        end

      end

      it "recieves the message when the subscriber comes back on line" do
        eventually do
          @state[:event_recieved].must_equal true
        end
      end
    end
  end
end
