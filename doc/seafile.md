# seafile on mac
-----

## required
   docker  
   
   [Install docker](https://docs.docker.com/install/)
## 1.pull the image
   Before this step, you need to start docker.  
    
    docker pull jenserat/seafile:latest
    
## 2.build directory for data storage
    mkdir /Users/app/seafile
    
## 3.download seafile-server
    cd /Users/app/seafile
  [https://www.seafile.com/download](https://www.seafile.com/download)  
  
   download seafile-server_6.2.5_x86-64.tar.gz  
   
    tar -xvf  seafile-server_6.2.5_x86-64.tar.gz
## 4.run the docker
    sudo docker run --name seafile -p 10001:10001 -p 12001:12001  \
     -p 8000:8000 -p 8080:8080 -p 8082:8082 \ 
     -v /Users/app/seafile:/opt/seafile -d jenserat/seafile
     
    docker exec -it seafile bash
    
## 5.Configure the seafile-server
    cd /opt/seafile/seafile-server-6.2.5
    ./setup-seafile.sh
   following the step to configure the seafile-server
    
    

    Press [ENTER] to continue
    -----------------------------------------------------------------
    
    1. [server name]: seafile
    -----------------------------------------------------------------

    2.What is the ip or domain of this server?
    For example, www.mycompany.com, or, 192.168.1.101
    [This server's ip or domain]: 192.168.1.97
    -----------------------------------------------------------------
    
    3.Where would you like to store your seafile data? 
    Note: Please use a volume with enough free space.
    [default: /opt/seafile/seafile-data ] 
    -----------------------------------------------------------------

    4.What tcp port do you want to use for seafile fileserver?
    8082 is the recommended port.
    [default: 8082 ] 
    -----------------------------------------------------------------
    
    This is your config information:

    server name:        seafile
    server ip/domain:   192.168.1.97
    seafile data dir:   /opt/seafile/seafile-data
    fileserver port:    8082
    -----------------------------------------------------------------
   
    If the server is behind a firewall, remember to open these tcp ports:
    ----------------------------------
    port of seafile fileserver:   8082
    port of seahub:               8000



## 6.start seafile-server
    ./seafile.sh start
    ./seahub.sh start
    
## using
   
  Enter "IP:8000" in the browser
    
    

