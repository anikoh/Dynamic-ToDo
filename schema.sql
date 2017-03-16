CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400) NOT NULL,
  password_digest VARCHAR(400) NOT NULL
);



CREATE TABLE categories(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(400) NOT NULL,
  importance INTEGER,
  user_id INTEGER
);


CREATE TABLE projects(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(400) NOT NULL,
  importance INTEGER,
  urgency INTEGER,
  category_id INTEGER
);




CREATE TABLE tasks(
  id  SERIAL4 PRIMARY KEY,
  name VARCHAR(400) NOT NULL,
  importance INTEGER,
  urgency INTEGER,
  completed BOOLEAN,
  user_id INTEGER,
  estimated_time INTEGER, --in minutes
  project_id INTEGER,
  on_list BOOLEAN,
  score FLOAT
);
