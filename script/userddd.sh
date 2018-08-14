#!/bin/bash


        for (( i=1;i<=$1;i++ ))

        do
                useradd user$i

                echo "123456" | passwd --stdin user$i >> /dev/null
        done


		#!/bin/bash

     for (( i=1;i<=$1;i++ ))

        do

                userdel -r user$i

        done
~                                                                                                  
~              
