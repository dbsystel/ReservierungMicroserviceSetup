ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

curl -L  https://github.com/coreos/etcd/releases/download/v2.3.3/etcd-v2.3.3-linux-amd64.tar.gz -o etcd-v2.3.3-linux-amd64.tar.gz
tar xzvf etcd-v2.3.3-linux-amd64.tar.gz
cd etcd-v2.3.3-linux-amd64
sudo chmod a+x etcd
sudo cp etcd /usr/local/bin/etcd 
sudo mkdir /var/etcd

sudo echo "start on (net-device-up
          and local-filesystems
          and runlevel [2345])
      stop on runlevel [016]

      respawn

      script
      chdir /var/etcd
      exec /usr/local/bin/etcd -name node1 -listen-peer-urls http://0.0.0.0:2380 -listen-client-urls http://0.0.0.0:2379,http://127.0.0.1:4001 -initial-advertise-peer-urls http://$ADVERTISE_ADDRESS:2380 -initial-cluster node1=http://$ADVERTISE_ADDRESS:2380 -initial-cluster-state new -initial-cluster-token etcd-cluster -advertise-client-urls http://$ADVERTISE_ADDRESS:2379 >>/var/log/etcd.log 2>&1
end script" >> etcd.conf

sudo cp etcd.conf /etc/init/etcd.conf

sudo service etcd start
