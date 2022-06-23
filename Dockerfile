FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]
RUN apt-get install software-properties-common
RUN apt-add-repository universe
# Install dependencies:
RUN apt-get update \
 && apt-get install -y \
    bash curl sudo wget \
    python3 unzip sed \
    python3-pip unzip \
    systemd golang \
 && pip3 install requests setuptools pynzbget chardet six 
 
RUN pip3 install apprise==0.9.7

RUN apt-get install unrar

# Clean up APT:
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set work dir:
WORKDIR /home

# Install NZBGET and gclone:
RUN wget https://nzbget.net/download/nzbget-latest-bin-linux.run \
 && bash nzbget-latest-bin-linux.run \
 && curl -s https://raw.githubusercontent.com/oneindex/script/master/gclone.sh | sudo bash
  

# Create required dirs:
RUN mkdir -p /home/nzbget/maindir/ \
 && mkdir -p /home/.config/rclone/ \
 #&& mkdir -p /home/nzbget/scripts/videosort/ \
 #&& mkdir -p /home/nzbget/scripts/videosort/lib/ 
# Copy files:

COPY start /home/
COPY gclone_pp.py /home/nzbget/scripts/
COPY Notify.py /home/nzbget/scripts/
COPY ping.py /home/
#COPY VideoSort.py /home/nzbget/scripts/videosort/
#COPY pkg_resources.py six.py /home/nzbget/scripts/videosort/lib/
#COPY lib/ /home/nzbget/scripts/videosort/lib/

#RUN ls -la /home/nzbget/scripts/videosort/lib/*

RUN chmod +x /home/nzbget/scripts/Notify.py
#RUN chmod +x /home/nzbget/scripts/videosort/VideoSort.py
# Run NZBGET:
CMD bash /home/start
