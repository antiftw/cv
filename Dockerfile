FROM arm32v7/ruby:3.0-slim-buster as jekyll

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    node \
    python-pygments \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/
RUN wget https://cmake.org/files/v3.10/cmake-3.10.1.tar.gz
RUN tar xzf cmake-3.10.1.tar.gz && rm cmake-3.10.1.tar.gz

RUN cd cmake-3.10.1 && ls && ./configure --prefix=/opt/cmake  && make
RUN  cd cmake-3.10.1 &&  make install


RUN gem install \
  github-pages \
  jekyll \
  jekyll-redirect-from \
  kramdown \
  rdiscount \
  rouge
VOLUME /src
EXPOSE 4000
WORKDIR /src
RUN cd /bin && ln -s /opt/cmake/bin/cmake cmake

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV JEKYLL_ENV production
ENTRYPOINT ["bash"]