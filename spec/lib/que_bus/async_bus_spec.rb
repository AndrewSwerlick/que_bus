require_relative '../../async_spec_helper'

describe Bus do
  describe "when we create a new bus" do
    let(:bus) {Bus.new }

    describe "when we have a subscriber in the database that is not currently connected
      and we publish a message and then connect the subscriber" do
      before do
        Subscriber.create(id: "test", job_class: "Jobs::Jobtest")
        bus.publish("reconnect_test")
        bus.subscribe("test") do
          byebug
          @event_recieved = true
        end

      end

      it "recieves the message when the subscriber comes back on line" do
        sleep(5)
        byebug
        @event_received.must_equal true
      end
    end
  end
end
