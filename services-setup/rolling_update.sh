sudo docker -H :4000 pull bachelorproject/$1service2
sudo docker -H :4000 stop $(sudo docker -H :4000  ps --filter name=$1service -aq)
sudo docker -H :4000 rm -v $(sudo docker -H :4000 ps --filter name=$1service -aq)

i=1
while [[ $i -le $2 ]]
do
    sudo docker -H :4000 run --name $1service$i  --net-alias=$1service  --net=reservierung -d bachelorproject/$1service2
    ((i = i + 1))
done
