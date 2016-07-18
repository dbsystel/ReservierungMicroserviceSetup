#Setup Infrastructure
cd "infrastructure-installation"
docker-compose -H :4000 up -d

#Attach Rabbit-Instances
i=1
while [[ $i -le $1 ]]
do
    sudo docker -H :4000 run --name rabbit$i --hostname=rabbit$i --net-alias=rabbit  --net=reservierung -e CLUSTERED=true -e CLUSTER_WITH=rabbitroot -d bachelorproject/rabbitcluster
    ((i = i + 1))
done

#Attach cassandra
i=1
while [[ $i -le $1 ]]
do
    sudo docker -H :4000 run --name cassandra-$i  --net-alias=cassandra  --net=reservierung -e CASSANDRA_BROADCAST_ADDRESS=cassandra-$i -e CASSANDRA_SEEDS=cassandraroot -d cassandra
    ((i = i + 1))
done

#Create Seat Database Copies
i=1
while [[ $i -le $1 ]]
do
    sudo docker -H :4000 run --name seat_database_copy$i  --net-alias=seat_database_copy  --net=reservierung -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=seatmanagement -d bachelorproject/seat_database_copy
    ((i = i + 1))
done

#wait until everything should be initialized
sleep 30
cd "testdata"
#Initialize data

sudo docker -H :4000 exec -i seat_database mysql -uroot -proot < seat_init.sql
sudo docker -H :4000 exec -i customer_database mysql -uroot -proot < customer_init.sql
sudo docker -H :4000 exec -i cassandraroot cqlsh < booking_init.cql

#Init Copies

i=1
while [[ $i -le $1 ]]
do
    sudo docker -H :4000 exec -i seat_database_copy$i mysql -uroot -proot < seat_copy.sql
    ((i = i + 1))
done

sleep 20

#setup services
cd "../../services-setup"

#scale services
docker-compose -H :4000 scale seatoverviewservice=$1 seatmanagementservice=$1 bookingservice=$1 customermanagementservice=$1 pricingservice=3 ui=$1