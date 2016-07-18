create keyspace booking with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3};
use booking;
create table booking ( id text primary key, payment_method text, customer_id int) ;
create table partial_booking ( id text primary key, booking_id text, seat_id int, train_connection_id int, start text, destination text, price double, departure_time bigint, arrival_time bigint, state text );
create index booking_index on partial_booking(booking_id);
create index customer_index on booking(customer_id);
create index seat_index on partial_booking(seat_id);
