module QueBus
  class Subscriber <ActiveRecord::Base
    self.table_name = "que_bus_subscribers"
    serialize :topics

  end
end
