CREATE TABLE que_bus_subscribers
(
  subscriber_id uuid        PRIMARY KEY,
  job_class     text        NOT NULL,
  topcs         text
);
