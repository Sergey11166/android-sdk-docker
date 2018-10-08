FROM openjdk:8-jdk

RUN mkdir -p /opt/android-sdk-linux && mkdir -p ~/.android && touch ~/.android/repositories.cfg

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=PATH=${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:$PATH
ENV ANDROID_SDK_TOOLS_ZIP_FILE=sdk-tools-linux-4333796.zip

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends unzip wget sudo
	   
# Download Android SDK
ADD https://dl.google.com/android/repository/${ANDROID_SDK_TOOLS_ZIP_FILE} /opt
RUN unzip /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} -d ${ANDROID_HOME} && \
	rm -f /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} && \
	echo y | sdkmanager "build-tools;28.0.3" "platforms;android-28" && \
	echo y | sdkmanager "system-images;android-28;google_apis;x86_64" && \
	echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository"

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get autoremove -y && \
	apt-get clean
