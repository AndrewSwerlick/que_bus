class TestClass < Que::Job
  def run(message)
    message[:event_recieved] = true
  end
end
