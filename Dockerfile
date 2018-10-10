FROM openjdk:8-jdk

RUN apt-get -q --yes update && apt-get -q --yes install lib32stdc++6 lib32z1 

RUN mkdir -p /opt/android-sdk-linux && mkdir -p /root/.android && touch /root/.android/repositories.cfg

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=PATH=${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:$PATH
ENV ANDROID_SDK_TOOLS_ZIP_FILE=sdk-tools-linux-3859397.zip

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends unzip wget sudo
	   
# Download Android SDK
ADD https://dl.google.com/android/repository/${ANDROID_SDK_TOOLS_ZIP_FILE} /opt
RUN unzip /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} -d ${ANDROID_HOME} && \
	rm -f /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} && \
	mkdir $ANDROID_HOME/licenses && \
  	echo "601085b94cd77f0b54ff86406957099ebe79c4d6" >> $ANDROID_HOME/licenses/android-googletv-license && \
  	echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> $ANDROID_HOME/licenses/android-sdk-license && \
  	echo "84831b9409646a918e30573bab4c9c91346d8abd" >> $ANDROID_HOME/licenses/android-sdk-preview-license && \
  	echo "33b6a2b64607f11b759f320ef9dff4ae5c47d97a" >> $ANDROID_HOME/licenses/android-gdk-license && \
  	echo "e9acab5b5fbb560a72cfaecce8946896ff6aab9d" >> $ANDROID_HOME/licenses/mips-android-sysimage-license && \
	echo y | sdkmanager --update && \
	echo y | sdkmanager "build-tools;28.0.3" "platforms;android-28" && \
	echo y | sdkmanager "system-images;android-19;default;armeabi-v7a" && \
	echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository"

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get autoremove -y && \
	apt-get clean
