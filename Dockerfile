FROM ubuntu:precise

# Upgrade OS
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt.sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install Java
RUN apt-get install software-properties-common python-software-properties -y
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install oracle-java7-installer -y

# Install YouTrack
RUN useradd -m youtrack
RUN wget -O /home/youtrack/wrapper-linux-x86-64-3.5.6.tar.gz http://wrapper.tanukisoftware.com/download/3.5.6/wrapper-linux-x86-64-3.5.6.tar.gz
RUN cd /home/youtrack; tar -zxf wrapper-linux-x86-64-3.5.6.tar.gz
RUN cd /home/youtrack; mv wrapper-linux-x86-64-3.5.6 standalone
RUN wget -O /home/youtrack/standalone/youtrack-5.2-8723.jar http://download.jetbrains.com/charisma/youtrack-5.2-8723.jar
RUN ln -s /home/youtrack/standalone/youtrack-5.2-8723.jar /home/youtrack/standalone/youtrack.jar
RUN rm /home/youtrack/wrapper-linux-x86-64-3.5.6.tar.gz

# Configure YouTrack
ADD wrapper.conf /home/youtrack/standalone/conf/wrapper.conf
RUN chown -R youtrack:youtrack /home/youtrack
ADD start-youtrack.sh /home/youtrack/start-youtrack.sh
RUN chmod +x /home/youtrack/start-youtrack.sh

# Entry
ENTRYPOINT /home/youtrack/start-youtrack.sh
EXPOSE 8080