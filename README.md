# Kubernetes Multitenancy and Secret Management Lab


## Deployment Steps

### Deploy Kubernetes

```bash
$ cd scripts
$ ./create_cluster.sh
```

### Deploy OpenUnison

```bash
$ ./setup_openunison.sh
```

#### Make Port 443 Public

First, click on ***PORTS*** to the right of your terminal tab:

![PORTS tab](./docs/imgs/ports.png "PORTS tab")

Next, right click on ***443*** and choose ***Port Visibility*** --> ***Public***

![Make 443 public](./docs/imgs/make-443-public.png "Make Port 443 Public")

#### Make Port 10444 and port 10445 HTTPS and Public

Next, make port 10444 **HTTPS** by right clicking on port 10444 and choosing ***Change Port Protocol*** --> ***HTTPS***
![Make 10444 HTTPS](./docs/imgs/make-10444-https.png "Make Port 10444 HTTPS")

The next step is to make port 10444 public.  Right click on port 10444 and choose ***Port Visibility*** --> ***Public***

![Make 10444 public](./docs/imgs/make-10444-public.png "Make Port 10444 Public")

Once port 10444 is made public, repeat these same steps on port 104445.

#### Access OpenUnison and the Kubernetes Dashboard

Once all three ports are public and HTTPS, you can login to OpenUnison by copying the URL of port 443 by right clicking on the port and selecting ***Copy Address***.  You can open this address in a browser.  You'll be presented with a login screen.  Use the username `mmosley` and the password `start123`:

![OpenUnison Login](./docs/imgs/openunison-login.png "OpenUnison Login").

Once you're logged in, in the middle of the screen click on ***vCluster Control Plane*** and then the ***Kubernetes Dashboard*** badge.  This will let you easily monitor pods as they run.  You can also click on the ***Kubernetes Tokens*** badge to get a generated kubectl to access your cluster locally.  ***NOTE:*** Because of how GitHub spaces works, neither port forwarding nor exec will work locally.

![OpenUnison Portal](./docs/imgs/openunison-portal.png "OpenUnison Portal").

#### Verify Setup before AKEYLESS Integration

The final step before integrating AKEYLESS is to verify that your port 443 is publicly available.  Copy the 443 URL as before and from a local terminal, run curl adding `/auth/idp/k8sIdp/.well-known/openid-configuration`.  As an example:

```sh
$ curl https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/.well-known/openid-configuration
{
  "issuer": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp",
  "authorization_endpoint": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/auth",
  "token_endpoint": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/token",
  "userinfo_endpoint": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/userinfo",
  "revocation_endpoint": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/revoke",
  "jwks_uri": "https://fuzzy-doodle-9r7w9gjxvv2jg7-443.app.github.dev/auth/idp/k8sIdp/certs",
  "response_types_supported": [
.
.
.
```

If you don't get any output, this means that your port 443 is not setup correctly.  Please go back make port 443 public.

### Integrate akeyless

Login to akeylesss as an administrator.  In the upper right hand corner, click on your face/user settings.  There's an option for ***Copy Token***.  Click on it.  This will copy the token to your clipboard.  

![AKEYLESS Token](./docs/imgs/akeyless-token.png "AKEYLESS Token")

Next, run `scripts/init-akeyless.sh`.  When prompted for a token, paste it

```bash
$ cd scripts
$ ./initialze-akeyless.sh 
--2024-09-27 17:52:39--  https://github.com/charmbracelet/gum/releases/download/v0.14.5/gum_0.14.5_amd64.deb
Resolving github.com (github.com)... 140.82.112.4
Connecting to github.com (github.com)|140.82.112.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/502193049/119b7537-5bce-4aa3-9f64-bcfbf259edef?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240927%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240927T175207Z&X-Amz-Expires=300&X-Amz-Signature=230ac288dc180fd5edf233c2a61484407699c6cabda334a7e04c644c198794c0&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dgum_0.14.5_amd64.deb&response-content-type=application%2Foctet-stream [following]
--2024-09-27 17:52:39--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/502193049/119b7537-5bce-4aa3-9f64-bcfbf259edef?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240927%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240927T175207Z&X-Amz-Expires=300&X-Amz-Signature=230ac288dc180fd5edf233c2a61484407699c6cabda334a7e04c644c198794c0&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dgum_0.14.5_amd64.deb&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.109.133, 185.199.110.133, 185.199.108.133, ...
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4488424 (4.3M) [application/octet-stream]
Saving to: ‘/tmp/gum_0.14.5_amd64.deb.22’

gum_0.14.5_amd64.deb.22                                                                                                     100%[=========================================================================================================================================================================================================================================================================================================================================>]   4.28M  --.-KB/s    in 0.05s   

2024-09-27 17:52:39 (86.1 MB/s) - ‘/tmp/gum_0.14.5_amd64.deb.22’ saved [4488424/4488424]

(Reading database ... 70128 files and directories currently installed.)
Preparing to unpack /tmp/gum_0.14.5_amd64.deb ...
Unpacking gum (0.14.5) over (0.14.5) ...
Setting up gum (0.14.5) ...
Processing triggers for man-db (2.9.1-1) ...
AKEYLESS-CLI, first use detected
For more info please visit: https://docs.akeyless.io/docs/cli
Version: 1.112.0.958540b
Association ass-mvqh220h02wegdgp7991 was successfully created
```

#### Setup SSO with akeyless

```bash
$ cd scripts
$ ./setup_akeyless_sso.sh
```

***If you see the error `failed to create auth method: Desc: auth method creation failed, Error: Desc: Failed to create auth method. Status 400 Bad Request, Error: InvalidParam. Message: account id: acc-eml1vex0l1Tm, access id: p-vbkes1ww9i6uam. Desc: Failed to create access. Status 400 Bad Request, Error: InvalidAccessParams. Message: failed to load provider issuer`, the 443 port forwarder is not set to public***

Once SSO is setup, you can login to OpenUnison using the user `mmosley` and the password `start123`.  Then you can click on the AKEYLESS badge:

![AKEYLESS SSO](./docs/imgs/akeyless-sso.png "AKEYLESS SSO")

#### Setup Gateway

```bash
$ cd scripts
$ ./setup_akeyless_gateway.sh
```

Follow the same process for port 10446 as you did for 10444 and 10445 above to make it both HTTPS and public.



```bash
Every 2.0s: kubectl get pods -n akeyless                                                                                                                                                                                                                                                                                                                                                                                 codespaces-9076fc: Tue Sep 10 14:21:16 2024

NAME                                      READY   STATUS    RESTARTS   AGE
gw-akeyless-api-gateway-7c8bcdb55-7wdxs   0/1     Running   0          2m
gw-akeyless-api-gateway-7c8bcdb55-z96bv   0/1     Running   0          2m
```

Once the gateways are running, login to the akeyless console, then:

1. Users & Auth Methods
2. openunison
3. Add `https://githubspaceshost-10446.app.github.dev/gw/login-oidc` to Allowed Redirect URIs where githubspaceshost is the name of your github codespace

Setup Kubernetes Authentication

```bash
$ cd scripts
$ ./setup_k8s_auth_cp.sh
```

Wait for the gateways to start running again

```bash
Every 2.0s: kubectl get pods -n akeyless                                                                                                                                                                                                                                                                                                                                                                                 codespaces-9076fc: Tue Sep 10 14:21:16 2024

NAME                                      READY   STATUS    RESTARTS   AGE
gw-akeyless-api-gateway-7c8bcdb55-7wdxs   0/1     Running   0          2m
gw-akeyless-api-gateway-7c8bcdb55-z96bv   0/1     Running   0          2m
```

Once the gateways are both at 1/1 again, login to OpenUnison with the user `mmosley` and the password `start123`.  You can click on the ***AKEYLESS Gateway*** badge to access the local version of your AKEYLESS configuration dashboard:

![AKEYLESS Gateway](./docs/imgs/akeyless-gateway.png "AKEYLESS Gateway")

### Deploying a Tenant

With OpenUnison and AKEYLESS integrated, the next step is to request a new tenant.  Login to OpenUnison with the username `mmosley` and the password `start123`.  Click on the ***New Kubernetes Namespace*** badge.

![New Kubernetes Namespace](./docs/imgs/newns1.png "New Kubernetes Namespace")

Fill out the form as seen in the screenshot with the below values:

| Option | Value |
| ------ | ----- |
| Cluster | vCluster Control Plane |
| Namespace Name | tenant1 |
| Dashboard Port | 11444 |
| API Server Port | 11445 |
| Administrators Group | cn=k8s-cluster-admins,ou=Groups,DC=domain,DC=com |
| Viewer Group | cn=vcluster-test-view,ou=Groups,DC=domain,DC=com |
| Reason | Demp |

![New Kubernetes Namespace](./docs/imgs/newns2.png "New Kubernetes Namespace")