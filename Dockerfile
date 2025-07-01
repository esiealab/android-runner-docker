FROM ubuntu:22.04

ARG ANDROID_RUNNER_GIT_REPO="https://github.com/esiealab/android-runner.git"        

# Work in app dir by default.
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    python3 \
    python3-pip \
    python3-lxml \
    git \
    build-essential \
    openjdk-17-jre \
    openjdk-8-jre \
    unzip \
    adb \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo '--- Installing Android Runner' && \
    git clone ${ANDROID_RUNNER_GIT_REPO} . && \
    pip install -r requirements.txt

ENTRYPOINT ["python3", "__main__.py"]
CMD ["./examples/android/config.json"]