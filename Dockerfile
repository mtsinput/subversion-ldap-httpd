FROM httpd:2.4
LABEL maintainer="Yan"

# For information about these parameters see 
# https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html
ARG AuthLDAPURL
ARG AuthLDAPBindDN
ARG AuthLDAPBindPassword
ARG RequireLDAPGroup

RUN apt-get update && apt-get --yes --force-yes --no-install-recommends install curl subversion libapache2-mod-svn ca-certificates \
   && apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /my-docker-entrypoint.sh
RUN chmod 755 /my-docker-entrypoint.sh

WORKDIR /usr/local/apache2
RUN echo "Include conf/extra/vife.conf" >> conf/httpd.conf

EXPOSE 80
VOLUME ["/var/svn"]
ENTRYPOINT ["/my-docker-entrypoint.sh"]
CMD ["httpd-foreground"]