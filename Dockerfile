# From the node docker image 
FROM node:latest
MAINTAINER sanghlee@hotmail.ca

# Install dependencies
RUN apt-get update && \
    apt-get -y install sudo && \
    apt-get -y install curl && \
    apt-get -y install git && \
    apt-get -y install nginx 

# Prepare working folder
RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

# Cloning the Sudoku Web App from the Git
RUN git clone https://github.com/hotdeveloper/sudoku-frontend-with-backend-2.git .
RUN chown -R node:node /home/node/app/client

# Configure nginx
RUN rm -rf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/

# Shell script for launching the nginx and the web app
COPY run.sh /home/node/app/

# Build web app
USER node
RUN npm run build
COPY --chown=node:node . .

# Expose nginx port to the world.
EXPOSE 8080

# Launching the Web App and Nginx
USER root
CMD ["sh", "run.sh"]
