FROM rocker/verse 
WORKDIR .
COPY . .
# RUN R -e "install.packages(\"matlab\")"
# RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y python3-pip
# RUN pip3 install tensorflow