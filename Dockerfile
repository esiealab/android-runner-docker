FROM ubuntu:22.04

ARG ANDROID_COMMANDLINE_TOOLS_FILE_LINK="https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip"
ARG ANDROID_RUNNER_GIT_REPO="https://github.com/esiealab/android-runner.git"
ARG ANDROID_SDK_FOLDER="/android-sdk"

# Work in app dir by default.
WORKDIR /app

RUN export DEBIAN_FRONTEND=noninteractive && \
    sed -i'' 's@http://archive.ubuntu.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@' /etc/apt/sources.list && \
    echo '--- Updating repositories' && \
    apt-get update && \
    echo '--- Upgrading repositories' && \
    apt-get -y dist-upgrade && \
    apt-get -y install wget python3 python3-pip python3-lxml git build-essential openjdk-17-jre openjdk-8-jre unzip 

RUN echo '--- Installing Android SDK' && \
    mkdir -p ${ANDROID_SDK_FOLDER}/cmdline-tools && \
    wget -O /tmp/commandlinetools-linux.zip ${ANDROID_COMMANDLINE_TOOLS_FILE_LINK}  && \
    unzip -q /tmp/commandlinetools-linux.zip -d ${ANDROID_SDK_FOLDER}/cmdline-tools && \
    rm -f /tmp/commandlinetools-linux.zip && \
    mv ${ANDROID_SDK_FOLDER}/cmdline-tools/cmdline-tools/ ${ANDROID_SDK_FOLDER}/cmdline-tools/latest/ && \
    cd ${ANDROID_SDK_FOLDER}/cmdline-tools/latest/bin && \
    yes | ./sdkmanager "tools" "build-tools;30.0.0" "platform-tools"

ENV PATH="$PATH:${ANDROID_SDK_FOLDER}/platform-tools:${ANDROID_SDK_FOLDER}/cmdline-tools/bin"

RUN echo '#!/bin/bash' > ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 && \
    echo 'exec "'${ANDROID_SDK_FOLDER}'/tools/bin/monkeyrunner" "$@"' >> ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 && \
    chmod +x ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 && \
    ln -s ${ANDROID_SDK_FOLDER}/monkeyrunner-java8 /bin/monkeyrunner

RUN echo '--- Installing Android Runner' && \
    git clone ${ANDROID_RUNNER_GIT_REPO} . && \
    pip install -r requirements.txt && pip install python-telegram-bot

ENTRYPOINT ["python3", "__main__.py"]
CMD ["./examples/android/config.json"]

