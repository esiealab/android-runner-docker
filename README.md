# android-runner-docker

This project provides a Dockerized environment for running Android experiments using [android-runner](https://github.com/esiealab/android-runner).

## 1. Build the Docker Image

First, build the Docker image using the provided `docker-compose.yml` file:

```sh
docker compose build
```

You can configure which git repository is used to install `android-runner` by setting the `ANDROID_RUNNER_GIT_REPO` build argument.  
Similarly, you can specify the Android command line tools archive with the `ANDROID_COMMANDLINE_TOOLS_FILE_LINK` build argument.

For example, in `docker-compose.yml`:

```yaml
build:
  context: .
  dockerfile: Dockerfile
  args: 
    - ANDROID_RUNNER_GIT_REPO=https://github.com/esiealab/android-runner.git
    - ANDROID_COMMANDLINE_TOOLS_FILE_LINK=https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip  
```

This will create the `android-runner-esiealab:latest` image with all required dependencies.


## 2. Configure an Experiment

Experiments are defined in the `experiment` folder. Each experiment has its own configuration file (e.g., `config_web.json`) and scripts in the `Scripts/` subfolder.

### Example: Running the Web Experiment

1. **Edit your experiment configuration**  
   The file [`experiment/config_web.json`](experiment/config_web.json) defines the devices, browsers, paths, profilers, and scripts to use.

2. **Check your device mapping**  
   The file [`devices.json`](devices.json) maps logical device names to their serial numbers or network addresses.

3. **Review the Docker Compose file**  
   The file [`docker-compose-exp1.yml`](docker-compose-exp1.yml) mounts the `experiment` folder and sets the command to `/exp/config_web.json`.

4. **Run the experiment**  
   Start the experiment with:

   ```sh
   docker-compose -f docker-compose-exp1.yml up
   ```

   This will launch the container, mount the experiment files, and execute the experiment as defined in your configuration.

## 3. Output

Experiment results will be saved in the `output/` subfolder inside the `experiment` directory.

---

**Note:**  
- You can create new experiments by copying the structure of the `experiment` folder and adapting the configuration and scripts as needed.
- Make sure to update the `volumes` and `command` fields in your Docker Compose file to point to your new experiment folder and config file.

For more details, see the [android-runner documentation](https://github.com/esiealab/android-runner).
