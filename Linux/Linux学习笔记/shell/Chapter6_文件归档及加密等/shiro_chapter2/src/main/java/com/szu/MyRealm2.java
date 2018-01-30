package com.szu;

import org.apache.shiro.authc.*;
import org.apache.shiro.realm.Realm;

import java.net.PasswordAuthentication;

public class MyRealm2 implements Realm {
    public String getName() {
        return "myRealm2";
    }

    public boolean supports(AuthenticationToken authenticationToken) {
        return authenticationToken instanceof UsernamePasswordToken;
    }

    public AuthenticationInfo getAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        String username = (String)authenticationToken.getPrincipal();
        String password = new String((char[]) authenticationToken.getCredentials());
        if ( !"wang".equals(username) ) {
            throw new UnknownAccountException();
        }
        if ( !"123".equals(password) ) {
            throw new IncorrectCredentialsException();
        }
        return new SimpleAuthenticationInfo(username, password, getName());
    }
}
