FROM Ubuntu

# Install necessary packages
RUN apt-get update -qq
RUN apt-get install -y build-essential nodejs npm nodejs-legacy vim

RUN mkdir /bounce-rate-app
ADD . /bounce-rate-app
WORKDIR /bounce-rate-app

# Install nodeJs packages
RUN npm install -g phantomjs
RUN npm install -g grunt-cli
RUN npm install -g grunt
RUN npm install -g bower
RUN npm install
RUN bower install --allow-root

EXPOSE 9999

CMD["grunt", "dev"]
