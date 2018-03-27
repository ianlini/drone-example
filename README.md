# drone-example

This is a Drone CI/CD example for single machine.
I build up this example to show a simple CI/CD use case: build docker image, test, and then deploy the system.
I assume that you have the drone server and agent on the same machine, and you also want to deploy your system that machine.
This setup helps us build up an example easier because we don't need to handle many secrets.
Don't use this example directly if someone you don't trust can push or send pull request to your repository.

## Preparation

- We will use Github's OAuth to login and get the repository, so you should register a new OAuth application [here](https://github.com/settings/applications/new).

- **Authorization callback URL** should be the URL you will run your drone server with `/authorize` suffix. For example, if you want to run your server on `http://123.123.123.123:8000`, then you must put `http://123.123.123.123:8000/authorize` here. Note that this must be a public IP, or Github cannot trigger the webhook.

- You can fill in whatever you want in other fields.

- Click **Register application** and then you will get your **Client ID** and **Client Secret**. You will need them later.

## Clone this repository

```bash
git clone https://github.com/ianlini/drone-example.git
cd drone-example
```

## Setup Drone server

Add `.env` to `drone-server/` with the following content:

```bash
DRONE_ADMIN=...
DRONE_HOST=...
DRONE_SECRET=...
DRONE_GITHUB_CLIENT=...
DRONE_GITHUB_SECRET=...
```

- `DRONE_ADMIN`: your Github username
- `DRONE_HOST`: your host address (e.g., `http://123.123.123.123:8000`)
- `DRONE_SECRET`: generate a random string and put it here
- `DRONE_GITHUB_CLIENT`: the **Client ID** you got in the previous step
- `DRONE_GITHUB_SECRET`: the **Client Secret** you got in the previous step

You can start your server with the docker-compose command now:

```bash
cd drone-server
docker-compose up -d
```

Now you can access your Drone web server from http://123.123.123.123:8000, and login using Github's OAuth.
