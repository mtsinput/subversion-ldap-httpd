#!/bin/sh

# add our svn location to the httpd config
cat <<EOF > /usr/local/apache2/conf/extra/vife.conf
LoadModule	authnz_ldap_module   modules/mod_authnz_ldap.so
# LoadModule	authz_svn_module     /usr/lib/apache2/modules/mod_authz_svn.so
LoadModule	dav_module           modules/mod_dav.so
LoadModule	dav_svn_module       /usr/lib/apache2/modules/mod_dav_svn.so
LoadModule	ldap_module          modules/mod_ldap.so
# rewriting Destination because we're behind an SSL terminating reverse proxy
# see http://www.dscentral.in/2013/04/04/502-bad-gateway-svn-copy-reverse-proxy/  
RequestHeader edit Destination ^https: http: early
<Location />
    DAV svn
    SVNParentPath /var/svn
    SVNListParentPath On
    AuthName "Please login" 
    AuthBasicProvider ldap
    AuthType Basic
    AuthLDAPGroupAttribute member
    AuthLDAPGroupAttributeIsDN on
    AuthLDAPURL ${AuthLDAPURL}
    AuthLDAPBindDN "${AuthLDAPBindDN}"
    AuthLDAPBindPassword "${AuthLDAPBindPassword}"
    Require valid-user
    <Limit HEAD GET OPTIONS PROPFIND REPORT>
        <RequireAny>
            # Read access
            Require valid-user
        </RequireAny>
    </Limit>
    <LimitExcept HEAD GET OPTIONS PROPFIND REPORT>
        <RequireAny>
            # Write access
            Require ldap-group ${RequireLDAPGroup}
        </RequireAny>                   
    </LimitExcept>
</Location>
EOF

# run the command given in the Dockerfile at CMD 
exec "$@"