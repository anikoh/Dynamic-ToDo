CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400) NOT NULL,
  password_digest VARCHAR(400) NOT NULL
);



CREATE TABLE tasks(
  id  SERIAL4 PRIMARY KEY,
  name VARCHAR(400) NOT NULL,
  importance INTEGER,
  urgency INTEGER,
  completed BOOLEAN,
  estimated_time TIME, --hours/min/sec, between 0 & 1 day
  time_begun TIMESTAMP,
  time_completed TIMESTAMP
  user_id INTEGER;
);
