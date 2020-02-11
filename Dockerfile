FROM circleci/android:api-28
MAINTAINER dev@airsorted.com

RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    python3-distutils \
    curl

ARG RUBY_VERSION=2.6.5
ARG NODE_VERSION=13.3.0
ARG YARN_VERSION=1.21.1

# Install ruby
ARG RUBY_INSTALL_VERSION=0.7.0
RUN cd /tmp && \
    wget -O ruby-install-${RUBY_INSTALL_VERSION}.tar.gz https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VERSION}.tar.gz && \
    tar -xzvf ruby-install-${RUBY_INSTALL_VERSION}.tar.gz && \
    rm ruby-install-${RUBY_INSTALL_VERSION}.tar.gz && \
    cd ruby-install-${RUBY_INSTALL_VERSION} && \
    sudo make install && \
    ruby-install --cleanup ruby ${RUBY_VERSION} && \
    rm -r /tmp/ruby-install-*

ENV PATH ${HOME}/.rubies/ruby-${RUBY_VERSION}/bin:${PATH}

RUN echo "gem: --no-document" >> ~/.gemrc
RUN gem install bundler

# Install node
RUN cd /tmp && \
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz && \
    tar -xzvf node-v${NODE_VERSION}.tar.gz && \
    rm node-v${NODE_VERSION}.tar.gz && \
    cd node-v${NODE_VERSION} && \
    ./configure && \
    make -j4 && \
    sudo make install && \
    rm -r /tmp/node-v${NODE_VERSION}

RUN curl -L https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn_${YARN_VERSION}_all.deb --output /tmp/yarn_${YARN_VERSION}_all.deb \
    && sudo dpkg -i /tmp/yarn_${YARN_VERSION}_all.deb \
    && rm /tmp/yarn_${YARN_VERSION}_all.deb

# Clean up apt
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
