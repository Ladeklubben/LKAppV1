include(Ladeklubben.pri)

#GOOGLE_FIREBASE_SDK = /opt/Firebase/firebase_cpp_sdk
#!isEmpty(GOOGLE_FIREBASE_SDK): INCLUDEPATH += $${GOOGLE_FIREBASE_SDK}/include

DISTFILES += \
    Doc/notes.txt \
    Ladeklubben.pri \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    fonts/fontello.ttf

#INSTALLS += windows/

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    include(android_openssl/openssl.pri)
}
