#!/bin/bash
#
# description: Apache Tomcat init script
# processname: tomcat
# chkconfig: 234 20 80
#
### BEGIN INIT INFO
# Provides:        tomcat8
# Required-Start:  2 3 4 5
# Required-Stop:   0 1 6
# Default-Start:   2 3 4 5
# Default-Stop:    0 1 6
# Short-Description: Start/Stop Tomcat server
### END INIT INFO

#Location of JAVA_HOME (bin files)
export JAVA_HOME=/opt/jdk1.8.0_211

#Add Java binary files to PATH
export PATH=$JAVA_HOME/bin:$PATH

#CATALINA_HOME is the location of the bin files of Tomcat
export CATALINA_HOME=/opt/apache-tomcat-8.5.50

#CATALINA_BASE is the location of the configuration files of this instance of Tomcat
export CATALINA_BASE=/opt/apache-tomcat-8.5.50/conf

#TOMCAT_USER is the default user of tomcat
export TOMCAT_USER=tomcat

#TOMCAT_USAGE is the message if this script is called without any options
TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"

#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20

tomcat_pid() {
        echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}

# Source function library.
. /etc/init.d/functions

start() {
echo "instart $(date)" > /tmp/tomcatscript.out
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mTomcat is already running (pid: $pid)\e[00m"
  else
echo "inelse $(date)" >> /tmp/tomcatscript.out
    # Start tomcat
    echo -e "\e[00;32mStarting tomcat\e[00m"
#    ulimit -n 100000
 #   umask 007
  #  /bin/su -p -s /bin/sh $TOMCAT_USER
        if [ `user_exists $TOMCAT_USER` = "1" ]
        then
                echo "in if then PID [$pid] whoami [$(whoami)] $(date)">> /tmp/tomcatscript.out
                echo "[$TOMCAT_USER] and [$CATALINA_HOME]" >> /tmp/tomcatscript.out
                daemon --user $TOMCAT_USER  $CATALINA_HOME/bin/startup.sh > /dev/null
#                sudo su - $TOMCAT_USER -s /bin/sh -c $CATALINA_HOME/bin/startup.sh >> /tmp/tomcatscript.out
                echo "called daemon" >>  /tmp/tomcatscript.out
        else
                echo "in else $(date)" >> /tmp/tomcatscript.out
                echo -e "\e[00;31mTomcat user $TOMCAT_USER does not exists. Starting with $(id)\e[00m"
                sh $CATALINA_HOME/bin/startup.sh
        fi
        echo "calling status $(date)">> /tmp/tomcatscript.out

       status >> /tmp/tomcatscript.out
  fi
  return 0
}

status(){
          pid=$(tomcat_pid)
          if [ -n "$pid" ]
            then echo -e "\e[00;32mTomcat is running with pid: $pid\e[00m"
          else
            echo -e "\e[00;31mTomcat is not running\e[00m"
            return 3
          fi
}
