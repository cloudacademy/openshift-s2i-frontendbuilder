# We are basing our builder image on nginx:latest
FROM nginx:mainline

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Platform for serving static HTML files" \
      io.k8s.display-name="Nginx 1.17.4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,nginx,cloudacademy,devops"

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# create a new doc root folder for serving owned by nginx
RUN mkdir -p /nginx/html
RUN touch /nginx/html/env-config.js
RUN chmod a+rw /nginx/html/env-config.js
RUN chown -R 1001:0 /nginx/html
RUN sed -i.bak1 's/root\(.*\)\/usr\/share\/nginx\/html;/root \/nginx\/html;/' /etc/nginx/conf.d/default.conf

# users are not allowed to listen on priviliged ports
RUN sed -i.bak2 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf
EXPOSE 8080

# comment user directive out as master process is run as user in openshift
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN addgroup nginx root

RUN apt-get update && apt-get install apt-file -y && apt-file update
RUN apt-get install -y vim
RUN apt-get install -y gnupg2
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y tree
RUN apt-get install -y procps

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

# Defines the location of the S2I
# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./s2i/bin/ /usr/local/s2i

#USER nginx
USER 1001
CMD ["/usr/libexec/s2i/usage"]