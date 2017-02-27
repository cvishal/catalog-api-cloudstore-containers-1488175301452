#Use the IBM Node image as a base image
FROM registry.ng.bluemix.net/ibmnode:latest

#Expose the port for your Personal Insights app, and set
#it as an environment variable as expected by cf apps
ENV PORT=3000
EXPOSE 3000
ENV NODE_ENV production

RUN git clone https://github.com/interconnect2017/Microservices-Catalog-Container
WORKDIR Microservices-Catalog-Container
RUN sudo apt-get -y  install curl
RUN curl -sSL https://github.com/amalgam8/amalgam8/releases/download/v0.4.0/a8sidecar.sh | sh
ENV A8_SERVICE=catalogservice:v1
ENV A8_ENDPOINT_PORT=3000
ENV A8_ENDPOINT_TYPE=http
ENV A8_REGISTRY_URL=http://micro-a8-registry.mybluemix.net
ENV A8_REGISTRY_POLL=60s
ENV A8_CONTROLLER_URL=http://micro-a8-controller.mybluemix.net
ENV A8_CONTROLLER_POLL=60s
ENV A8_LOG=enable_log

#Install any necessary requirements from package.json
RUN npm install

#Sleep before the app starts. This command ensures that the
#IBM Containers networking is finished before the app starts.
CMD (sleep 60; npm start)

#Start the Personal Insight app.
CMD  ["a8sidecar", "--register", "--supervise", "node" , "app.js"]
