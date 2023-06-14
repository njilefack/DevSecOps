###  This Guide provide Quick and Easy Steps to Deploy Sonarqube on Docker 

#### **Step 1: Deploy SonarQube**

- Deploy SonarQube with the following command;

```bash
docker run -d \
    -p 9000:9000 \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    --name sonaqube-server \
     sonarqube:community
```
#### **Step 2: Create Ngrok account**

- Ngrok is a simplified API-first ingress-as-a-service that adds connectivity, security, and observability to your apps in one line. You can sign-up [here](https://ngrok.com/product#:~:text=ngrok%20is%20a%20simplified%20API,Sign%20up%20for%20free).

- You can create an `Ngrok` account with already existed `GitHub` account. 

#### **Step 3: Expose Sonarqube With Ngrok**

`Ngrok` exposes with a via a unique url that overides use of `localhost:9000`. This `localhost:9000` may not resolve to sonarqube application causing the pipeline to fail. `Ngrok` creates a `hostname/domain name` that maps to `Slocalhost:9000`

- Once `Ngrok` account is created, navigate to Dashboard.
![Ngrok dashboard](./images/ngrok-dasboard.png)
- Click on the  drop-down botton infront of `Getting Started` then `Your AuthToken`.
- Copy your `Authtoken`.
- Deploy `Ngrok` that to expose sonarqube with this command;

```bash
docker run -d -p 4040:4040 --name ngrok  -e NGROK_AUTHTOKEN=<You Authtoken here> ngrok/ngrok:latest http host.docker.internal:9000
```
NB >
 `SonarQube` instance deployed earlier on is exposed externally on port `9000`. `Ngrok` will route internal http traffic to port `9000`

- You can find details of `Ngrok` configuration [here](https://ngrok.com/docs/using-ngrok-with/docker/).

#### **Step 4: Access Sonarqube via Ngrok**

- On your favorite browser lunch `localhost:4040`. you should see something like this.

