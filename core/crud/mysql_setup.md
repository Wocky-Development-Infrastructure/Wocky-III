
CREATE TABLE users(id INT,
username VARCHAR(18),
ip VARCHAR(15),
password VARCHAR(30),
plan INT,
maxtime INT,
conn INT,
ongoing INT,
admin INT,
expiry VARCHAR(20));

CREATE TABLE apis(id INT,
api_name VARCHAR(20),
api_url VARCHAR(255),
api_maxtime INT,
api_maxconn INT,
api_methods VARCHAR(255),
api_funnels VARCHAR(255),
api_toggle INT);