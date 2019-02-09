CREATE KEYSPACE IF NOT EXISTS apptenminutes
  WITH REPLICATION = {
   'class' : 'SimpleStrategy',
   'replication_factor' : 2
  };

use apptenminutes;

CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY,
  name text,
  email text,
  country text,
  company text,
  position text
);