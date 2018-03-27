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
- `DRONE_HOST`: your host address (e.g., http://123.123.123.123:8000)
- `DRONE_SECRET`: generate a random string and put it here
- `DRONE_GITHUB_CLIENT`: the **Client ID** you got in the previous step
- `DRONE_GITHUB_SECRET`: the **Client Secret** you got in the previous step

You can start your server with the docker-compose command now:

```bash
cd drone-server
docker-compose up -d
```

Now you can access your Drone web server from http://123.123.123.123:8000, and login using Github's OAuth.

## Configure for your repository

- You should be able to understand the following steps on the GUI easily, but I still provide the URL in case you cannot find them.

- Turn on your repository in the repositories page (e.g., http://123.123.123.123:8000/account/repos).

- Set the repository to be trusted because we want to link the volume in `.drone.yml`.
  - If your repository is `ianlini/drone-example`, then the setting page may be something like http://123.123.123.123:8000/ianlini/drone-example/settings.
  - This is a dangerous setting, make sure you know what this is if you are not just testing.
  - If your repository is public, you can also disable **pull request** in **Repository Hooks** so that no one can trigger your webhook using pull request.


## Trigger the webhook

- Now you can try to trigger the webhook by pushing.

- After pushing, you will see the build here: http://123.123.123.123:8000/ianlini/drone-example/.

- You can also see that the image is built on your machine (`build-docker` step in the pipeline), and the flake8 (python linter) is run using that image (`flake8` step in the pipeline).

- Note that only `build-docker` and `flake8` is run here because we set `when` for other steps in the pipeline so that they won't be triggered when pushing.

## Deploy

- The deployment can only be triggered using the command-line tool.

- Install the tool following the instruction [here](http://docs.drone.io/cli-installation/).

- Find your token here: http://123.123.123.123:8000/account/token. This page will tell you how to use the token:

```bash
export DRONE_SERVER=...
export DRONE_TOKEN=...
drone info
```

- Now you can deploy a previous build using the command:

```bash
drone deploy {your repository} {build number} {environment}
```

- Example:

```
drone deploy ianlini/drone-example 3 production
```

- This will trigger the `deploy-production` step in the pipeline.

- This may be failed because you haven't set the secret `EXAMPLE_SECRET`.

## Configure the secret

- We pass a secret to the python file `hello_world.py` to show the power of the secret management in Drone, so you should set it before deployment.

- Go to http://123.123.123.123:8000/ianlini/drone-example/settings/secrets and set a secret:
  - Secret Name: `example_secret`
  - Secret Value: `this is a secret`

- Now try to deploy again.
