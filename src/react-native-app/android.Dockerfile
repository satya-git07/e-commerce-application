FROM reactnativecommunity/react-native-android:v13.2.1 AS builder

# Set the working directory
WORKDIR /reactnativesrc/

# Copy the package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install node dependencies
RUN npm install

# Now copy the rest of the code (including the native modules) into the container
COPY . .

# Ensure the gradle wrapper is executable
WORKDIR /reactnativesrc/android/
RUN chmod +x gradlew

# Run the Gradle build to assemble the release APK
RUN ./gradlew clean && ./gradlew assembleRelease

# Create the final image
FROM scratch
COPY --from=builder /reactnativesrc/android/app/build/outputs/apk/release/app-release.apk /reactnativeapp.apk
ENTRYPOINT ["/reactnativeapp.apk"]

