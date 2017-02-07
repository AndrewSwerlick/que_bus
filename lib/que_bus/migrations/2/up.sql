CREATE TABLE que_bus_completed_events
(
  id            serial      PRIMARY KEY,
  event_id      UUID        NOT NULL,
  subscriber    text        NOT NULL
);
