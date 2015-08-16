CREATE TABLE que_bus_subscribers
(
  id            serial      PRIMARY KEY,
  subscriber_id text        UNIQUE,
  job_class     text        NOT NULL,
  topics        text
);
