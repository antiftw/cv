FROM arm64v8/ruby:3.0-buster as jekyll-minimal
RUN apt-get update && \
  apt-get install -y build-essential  && \
  apt-get install -y zlib1g-dev && \
  gem install jekyll bundler html-proofer && \
  mkdir /srv/jekyll

RUN addgroup --system --gid 1000 jekyll
RUN adduser --uid 1000 --system --ingroup jekyll jekyll

EXPOSE 80

WORKDIR /srv/jekyll
VOLUME  /srv/jekyll

COPY entrypoint /usr/jekyll/bin/entrypoint
RUN chmod +x /usr/jekyll/bin/entrypoint
ENTRYPOINT ["/usr/jekyll/bin/entrypoint"]

## Following is an adaptation of the official Jekyll Dockerfile
## However, it results in error when trying to run the image
## We leave it here because as a reference for possible issues 
## that might arise from the minimal image.

FROM arm64v8/ruby:3.0-slim-buster as jekyll
# 64bit:
# arm64v8/ruby:3.0-slim-buster
#
# EnvVars
# Ruby
#

ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_DISABLE_PLATFORM_WARNINGS=true
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem
ENV RUBYOPT=-W0

#
# EnvVars
# Image
#

ENV JEKYLL_VAR_DIR=/var/jekyll
# ENV JEKYLL_DOCKER_TAG=<%= @meta.tag %>
# ENV JEKYLL_VERSION=<%= @meta.release?? @meta.release : @meta.tag %>
# ENV JEKYLL_DOCKER_COMMIT=<%= `git rev-parse --verify HEAD`.strip %>
# ENV JEKYLL_DOCKER_NAME=<%= @meta.name %>
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_BIN=/usr/jekyll/bin
ENV JEKYLL_ENV=production

#
# EnvVars
# System
#

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=America/Chicago
ENV PATH="$JEKYLL_BIN:$PATH"
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

#
# EnvVars
# User
#

# <% if @meta.env? %>
#   ENV <%= @meta.env %>
# <% end %>

#
# EnvVars
# Main
#

ENV VERBOSE=false
ENV FORCE_POLLING=false
ENV DRAFTS=false


#
# Packages
# User
#

#<% if @meta.packages? %>
# RUN apk --no-cache add <%= @meta.packages %>
#<% end %>

#
# Packages
# Dev
#

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      libffi-dev \
      cmake

#  zlib-dev \
#       build-base \
#       imagemagick-dev \
#       readline-dev \
#       yaml-dev \
#       zlib-dev \
#       vips-dev \
#       vips-tools \
#       sqlite-dev \

#
# Packages
# Main
#

RUN apt-get install -y --no-install-recommends \
  default-jdk \
  less \
  libxml2 \
  git \
  nodejs \
  tzdata \
  bash \
  npm \
  yarn \
  jekyll

# linux-headers \
# openjdk8-jre \ -> replaced by default-jdk
#   zlib \
#   readline \
#   libxslt \
#   libffi \
#   shadow \
#   su-exec \
#   libressl \

#
# Gems
# Update
#

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN unset GEM_HOME && unset GEM_BIN && \
  yes | gem update --system

#
# Gems
# Main
#

RUN unset GEM_HOME && unset GEM_BIN && yes | gem install --force bundler

RUN bundle config build.nokogiri --use-system-libraries

# RUN gem install jekyll -v<%= @meta.release?? \
#   @meta.release : @meta.tag %> -- \
#     --use-system-libraries
RUN gem install jekyll bundler
#
# Gems
# User
#

# Stops slow Nokogiri!
# RUN gem install <%=@meta.gems %> -- \
#   --use-system-libraries
RUN gem install \ 
  html-proofer \
  jekyll-mentions \
  jekyll-coffeescript \
  jekyll-sass-converter \
  jekyll-commonmark \
  jekyll-paginate \
  jekyll-compose \
  RedCloth \
  kramdown \
  jemoji 

# https://github.com/sass-contrib/sass-embedded-host-ruby/issues/130
RUN gem install -f \
  github-pages \
  jekyll-reload \
  jekyll-assets


# Alpine syntax
# RUN addgroup -Sg 1000 jekyll
# RUN adduser  -Su 1000 -G \
#   jekyll jekyll
# Debian syntax
RUN addgroup --system --gid 1000 jekyll
RUN adduser --uid 1000 --system --ingroup jekyll jekyll

# RUN 
# RUN adduser  1000 --system --group jekyll jekyll
# RUN addgroup 1000 jekyll

RUN mkdir -p $JEKYLL_VAR_DIR
RUN mkdir -p $JEKYLL_DATA_DIR
RUN chown -R jekyll:jekyll $JEKYLL_DATA_DIR
RUN chown -R jekyll:jekyll $JEKYLL_VAR_DIR
RUN chown -R jekyll:jekyll $BUNDLE_HOME
RUN rm -rf /home/jekyll/.gem
RUN rm -rf $BUNDLE_HOME/cache
RUN rm -rf $GEM_HOME/cache
RUN rm -rf /root/.gem

# Work around rubygems/rubygems#3572
RUN mkdir -p /usr/gem/cache/bundle
RUN chown -R jekyll:jekyll \
  /usr/gem/cache/bundle

CMD ["jekyll", "--help"]
COPY entrypoint /usr/jekyll/bin/entrypoint
RUN chmod +x /usr/jekyll/bin/entrypoint
ENTRYPOINT ["/usr/jekyll/bin/entrypoint"]

WORKDIR /srv/jekyll
VOLUME  /srv/jekyll

EXPOSE 80