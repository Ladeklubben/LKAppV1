cmake_minimum_required(VERSION 3.27)
project(Ladeklubben VERSION 0.0.33 LANGUAGES C CXX)
set(VERSION_CODE 65)


message(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

# set(CMAKE_AUTORCC ON)
# set(CMAKE_AUTOMOC ON)
# set(CMAKE_AUTOUIC ON)


find_package(QT NAMES Qt5 Qt6 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core5Compat Gui Location Quick Svg WebView Charts LinguistTools QuickControls2 Multimedia)
find_package(Qt${QT_VERSION_MAJOR} OPTIONAL_COMPONENTS Concurrent)

qt_standard_project_setup(
    I18N_SOURCE_LANGUAGE en
    I18N_TRANSLATED_LANGUAGES dk
)

set(QRC_FILES
    widgets.qrc
    mapwidget.qrc
    electricity.qrc
    scripts.qrc
    ChargerSetup.qrc
    qml.qrc
    Account.qrc
    data.qrc
    Schedule.qrc
    groupwidgets.qrc
    fonts.qrc
    Password.qrc
    icons.qrc
    PaymentWidgets.qrc
    statwidgets.qrc
    Viewpages.qrc
    schedulewidgets.qrc
    guestwidgets.qrc
    Admin.qrc
    Installation.qrc
)

qt6_add_resources(RESOURCES_RCC
    ${QRC_FILES}
    #chargerwidgets.qrc
)

set (ALL_MY_LANGUAGES
    ${QT_I18N_SOURCE_LANGUAGE}
    ${QT_I18N_TRANSLATED_LANGUAGES}
)
# en can be duplicated (in source and translated language)
list(REMOVE_DUPLICATES ALL_MY_LANGUAGES)
set(MY_LANGUAGE_TS_FILES "")
foreach(lang ${ALL_MY_LANGUAGES})
  list(APPEND MY_LANGUAGE_TS_FILES "translations/${CMAKE_PROJECT_NAME}_${lang}.ts")
endforeach()
message(STATUS "MY_LANGUAGE_TS_FILES: ${MY_LANGUAGE_TS_FILES}")

set_source_files_properties(
    ${MY_LANGUAGE_TS_FILES}
    PROPERTIES OUTPUT_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/translations"
)


# set(TS_FILES
#     translations/lk_dk.ts
# )

set(COMMON_SOURCE_FILES
    main.cpp
    pushnotification.cpp pushnotification.h
    ${RESOURCES_RCC}
)

if(IOS)
    set(IOS_SOURCE_FILES
        ios/Assets.xcassets
        ios/ExportOptions.plist
    )

set_source_files_properties(
    ios/Assets.xcassets
    ios/ExportOptions.plist
    PROPERTIES
    MACOSX_PACKAGE_LOCATION Resources
)

endif()

if (ANDROID)
    include(${CMAKE_CURRENT_SOURCE_DIR}/android_openssl/android_openssl.cmake)
endif()

if(IOS)
    set(QT_USE_RISKY_DSYM_ARCHIVING_WORKAROUND ON)
endif()


qt_add_executable(Ladeklubben WIN32 MACOSX_BUNDLE
    ${COMMON_SOURCE_FILES}
    ${IOS_SOURCE_FILES}
    Installation.qrc
)

if (ANDROID)
    add_android_openssl_libraries(${CMAKE_PROJECT_NAME})
endif()

if(APPLE)
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
endif()

if(IOS)
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        # Bundle settings
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/ios/Info.plist.in"
        MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}"
        MACOSX_BUNDLE_EXECUTABLE_NAME "${PROJECT_NAME}"
        MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "${VERSION_CODE}"

        # Basic settings
        XCODE_GENERATE_SCHEME YES
        BUILD_WITH_INSTALL_RPATH YES
        XCODE_ATTRIBUTE_SKIP_INSTALL NO
        XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)"
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "dk.ladeklubben.app"
        XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY 1
        XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon"
        XCODE_ATTRIBUTE_VALIDATE_PRODUCT[variant=Release] YES

        # Try these linking settings
        XCODE_ATTRIBUTE_LINK_WITH_STANDARD_LIBRARIES "YES"
        XCODE_ATTRIBUTE_ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES "YES"
        XCODE_ATTRIBUTE_EMBEDDED_CONTENT_CONTAINS_SWIFT "NO"

        # Build settings
        XCODE_ATTRIBUTE_CONFIGURATION_BUILD_DIR "$(inherited)"
        XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT[variant=Release] "dwarf-with-dsym"
        XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS "YES"

        # Bitcode settings
        XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
        XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE "none"

        # Strip settings
        XCODE_ATTRIBUTE_STRIP_SWIFT_SYMBOLS[variant=Release] "YES"
        XCODE_ATTRIBUTE_STRIP_STYLE "all"
    )

set(IOS_SOURCE_FILES
    ios/Assets.xcassets
    ios/ExportOptions.plist
)

set_source_files_properties(
    ios/Assets.xcassets
    ios/ExportOptions.plist
    PROPERTIES
    MACOSX_PACKAGE_LOCATION Resources
)
endif()


# qt_add_translations(${CMAKE_PROJECT_NAME}
#     TS_FILES ${TS_FILES}
# )

add_custom_target(ladeklubben_other_files SOURCES
   ${TS_FILES}
)

qt_add_translations(${CMAKE_PROJECT_NAME}
    TS_FILE_DIR "translations"
    RESOURCE_PREFIX "/"
    NO_GENERATE_PLURALS_TS_FILE
    SOURCES ${QRC_FILES}
)
add_dependencies(${CMAKE_PROJECT_NAME} update_translations)
#qt_add_lupdate(${CMAKE_PROJECT_NAME} SOURCES ${QRC_FILES})

SET(QZXING_MULTIMEDIA ON)
SET(QZXING_USE_DECODER_QR_CODE ON)

add_subdirectory(./QZXing/)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/QZXing)
INCLUDE_DIRECTORIES(./QZXing)

target_compile_definitions(Ladeklubben PRIVATE
    APP_VERSION="${PROJECT_VERSION}"
    DISABLE_LIBRARY_FEATURES
    QT_DEPRECATED_WARNINGS
    QZXING_LIBRARY
    ZXING_ICONV_CONST
)

qt_add_ios_ffmpeg_libraries(Ladeklubben)

target_link_libraries(Ladeklubben PRIVATE
    Qt6::Core
    Qt::Core5Compat
    Qt::Gui
    Qt::Location
    Qt::Quick
    Qt::Svg
    Qt::WebView
    Qt::Charts
    qzxing
    #"-framework AVFoundation"
)


set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_VERSION_NAME ${PROJECT_VERSION}
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_VERSION_CODE ${VERSION_CODE}
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_TARGET_SDK_VERSION 34
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_MIN_SDK_VERSION 26
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)


if(enable_decoder_1d_barcodes)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/oned/CodaBarReader.cpp QZXing/zxing/zxing/oned/CodaBarReader.h
        QZXing/zxing/zxing/oned/Code128Reader.cpp QZXing/zxing/zxing/oned/Code128Reader.h
        QZXing/zxing/zxing/oned/Code39Reader.cpp QZXing/zxing/zxing/oned/Code39Reader.h
        QZXing/zxing/zxing/oned/Code93Reader.cpp QZXing/zxing/zxing/oned/Code93Reader.h
        QZXing/zxing/zxing/oned/EAN13Reader.cpp QZXing/zxing/zxing/oned/EAN13Reader.h
        QZXing/zxing/zxing/oned/EAN8Reader.cpp QZXing/zxing/zxing/oned/EAN8Reader.h
        QZXing/zxing/zxing/oned/EANManufacturerOrgSupport.cpp QZXing/zxing/zxing/oned/EANManufacturerOrgSupport.h
        QZXing/zxing/zxing/oned/ITFReader.cpp QZXing/zxing/zxing/oned/ITFReader.h
        QZXing/zxing/zxing/oned/MultiFormatOneDReader.cpp QZXing/zxing/zxing/oned/MultiFormatOneDReader.h
        QZXing/zxing/zxing/oned/MultiFormatUPCEANReader.cpp QZXing/zxing/zxing/oned/MultiFormatUPCEANReader.h
        QZXing/zxing/zxing/oned/OneDReader.cpp QZXing/zxing/zxing/oned/OneDReader.h
        QZXing/zxing/zxing/oned/OneDResultPoint.cpp QZXing/zxing/zxing/oned/OneDResultPoint.h
        QZXing/zxing/zxing/oned/UPCAReader.cpp QZXing/zxing/zxing/oned/UPCAReader.h
        QZXing/zxing/zxing/oned/UPCEANExtension2Support.cpp QZXing/zxing/zxing/oned/UPCEANExtension2Support.h
        QZXing/zxing/zxing/oned/UPCEANExtension5Support.cpp QZXing/zxing/zxing/oned/UPCEANExtension5Support.h
        QZXing/zxing/zxing/oned/UPCEANExtensionSupport.cpp QZXing/zxing/zxing/oned/UPCEANExtensionSupport.h
        QZXing/zxing/zxing/oned/UPCEANReader.cpp QZXing/zxing/zxing/oned/UPCEANReader.h
        QZXing/zxing/zxing/oned/UPCEReader.cpp QZXing/zxing/zxing/oned/UPCEReader.h
        QZXing/zxing/zxing/oned/rss/AbstractRSSReader.cpp QZXing/zxing/zxing/oned/rss/AbstractRSSReader.h
        QZXing/zxing/zxing/oned/rss/DataCharacter.cpp QZXing/zxing/zxing/oned/rss/DataCharacter.h
        QZXing/zxing/zxing/oned/rss/FinderPattern.cpp QZXing/zxing/zxing/oned/rss/FinderPattern.h
        QZXing/zxing/zxing/oned/rss/Pair.cpp QZXing/zxing/zxing/oned/rss/Pair.h
        QZXing/zxing/zxing/oned/rss/RSS14Reader.cpp QZXing/zxing/zxing/oned/rss/RSS14Reader.h
        QZXing/zxing/zxing/oned/rss/RSSUtils.cpp QZXing/zxing/zxing/oned/rss/RSSUtils.h
        QZXing/zxing/zxing/oned/rss/expanded/BitArrayBuilder.cpp QZXing/zxing/zxing/oned/rss/expanded/BitArrayBuilder.h
        QZXing/zxing/zxing/oned/rss/expanded/ExpandedPair.cpp QZXing/zxing/zxing/oned/rss/expanded/ExpandedPair.h
        QZXing/zxing/zxing/oned/rss/expanded/ExpandedRow.cpp QZXing/zxing/zxing/oned/rss/expanded/ExpandedRow.h
        QZXing/zxing/zxing/oned/rss/expanded/RSSExpandedReader.cpp QZXing/zxing/zxing/oned/rss/expanded/RSSExpandedReader.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013103decoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013103decoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01320xDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01320xDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01392xDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01392xDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01393xDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01393xDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013x0x1xDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013x0x1xDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013x0xDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI013x0xDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01AndOtherAIs.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01AndOtherAIs.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01decoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01decoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01weightDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AI01weightDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AbstractExpandedDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AbstractExpandedDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/AnyAIDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/AnyAIDecoder.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/BlockParsedResult.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/BlockParsedResult.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/CurrentParsingState.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/CurrentParsingState.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedChar.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedChar.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedInformation.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedInformation.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedNumeric.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedNumeric.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedObject.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/DecodedObject.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/FieldParser.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/FieldParser.h
        QZXing/zxing/zxing/oned/rss/expanded/decoders/GeneralAppIdDecoder.cpp QZXing/zxing/zxing/oned/rss/expanded/decoders/GeneralAppIdDecoder.h
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_DECODER_1D_BARCODES
)
endif()

if(enable_decoder_qr_code)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/multi/qrcode/QRCodeMultiReader.cpp QZXing/zxing/zxing/multi/qrcode/QRCodeMultiReader.h
        QZXing/zxing/zxing/multi/qrcode/detector/MultiDetector.cpp QZXing/zxing/zxing/multi/qrcode/detector/MultiDetector.h
        QZXing/zxing/zxing/multi/qrcode/detector/MultiFinderPatternFinder.cpp QZXing/zxing/zxing/multi/qrcode/detector/MultiFinderPatternFinder.h
        QZXing/zxing/zxing/qrcode/QRCodeReader.cpp
        QZXing/zxing/zxing/qrcode/decoder/BitMatrixParser.h
        QZXing/zxing/zxing/qrcode/decoder/DataBlock.h
        QZXing/zxing/zxing/qrcode/decoder/DataMask.h
        QZXing/zxing/zxing/qrcode/decoder/DecodedBitStreamParser.h
        QZXing/zxing/zxing/qrcode/decoder/Decoder.h
        QZXing/zxing/zxing/qrcode/decoder/QRBitMatrixParser.cpp
        QZXing/zxing/zxing/qrcode/decoder/QRDataBlock.cpp
        QZXing/zxing/zxing/qrcode/decoder/QRDataMask.cpp
        QZXing/zxing/zxing/qrcode/decoder/QRDecodedBitStreamParser.cpp
        QZXing/zxing/zxing/qrcode/decoder/QRDecoder.cpp
        QZXing/zxing/zxing/qrcode/detector/AlignmentPattern.h
        QZXing/zxing/zxing/qrcode/detector/AlignmentPatternFinder.h
        QZXing/zxing/zxing/qrcode/detector/Detector.h
        QZXing/zxing/zxing/qrcode/detector/FinderPattern.h
        QZXing/zxing/zxing/qrcode/detector/FinderPatternFinder.h
        QZXing/zxing/zxing/qrcode/detector/FinderPatternInfo.h
        QZXing/zxing/zxing/qrcode/detector/QRAlignmentPattern.cpp
        QZXing/zxing/zxing/qrcode/detector/QRAlignmentPatternFinder.cpp
        QZXing/zxing/zxing/qrcode/detector/QRDetector.cpp
        QZXing/zxing/zxing/qrcode/detector/QRFinderPattern.cpp
        QZXing/zxing/zxing/qrcode/detector/QRFinderPatternFinder.cpp
        QZXing/zxing/zxing/qrcode/detector/QRFinderPatternInfo.cpp
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_DECODER_QR_CODE
)
endif()

if(enable_encoder_qr_code)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/qrcode/encoder/BlockPair.h
        QZXing/zxing/zxing/qrcode/encoder/ByteMatrix.cpp QZXing/zxing/zxing/qrcode/encoder/ByteMatrix.h
        QZXing/zxing/zxing/qrcode/encoder/Encoder.h
        QZXing/zxing/zxing/qrcode/encoder/MaskUtil.cpp QZXing/zxing/zxing/qrcode/encoder/MaskUtil.h
        QZXing/zxing/zxing/qrcode/encoder/MatrixUtil.cpp QZXing/zxing/zxing/qrcode/encoder/MatrixUtil.h
        QZXing/zxing/zxing/qrcode/encoder/QRCode.cpp QZXing/zxing/zxing/qrcode/encoder/QRCode.h
        QZXing/zxing/zxing/qrcode/encoder/QREncoder.cpp
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_ENCODER_QR_CODE
)
endif()

if(enable_decoder_data_matrix)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/datamatrix/DataMatrixReader.cpp QZXing/zxing/zxing/datamatrix/DataMatrixReader.h
        QZXing/zxing/zxing/datamatrix/DataMatrixVersion.cpp
        QZXing/zxing/zxing/datamatrix/Version.h
        QZXing/zxing/zxing/datamatrix/decoder/BitMatrixParser.h
        QZXing/zxing/zxing/datamatrix/decoder/DataBlock.h
        QZXing/zxing/zxing/datamatrix/decoder/DataMatrixBitMatrixParser.cpp
        QZXing/zxing/zxing/datamatrix/decoder/DataMatrixDataBlock.cpp
        QZXing/zxing/zxing/datamatrix/decoder/DataMatrixDecodedBitStreamParser.cpp
        QZXing/zxing/zxing/datamatrix/decoder/DataMatrixDecoder.cpp
        QZXing/zxing/zxing/datamatrix/decoder/DecodedBitStreamParser.h
        QZXing/zxing/zxing/datamatrix/decoder/Decoder.h
        QZXing/zxing/zxing/datamatrix/detector/CornerPoint.h
        QZXing/zxing/zxing/datamatrix/detector/DataMatrixCornerPoint.cpp
        QZXing/zxing/zxing/datamatrix/detector/DataMatrixDetector.cpp
        QZXing/zxing/zxing/datamatrix/detector/DataMatrixDetectorException.cpp
        QZXing/zxing/zxing/datamatrix/detector/Detector.h
        QZXing/zxing/zxing/datamatrix/detector/DetectorException.h
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_DECODER_DATA_MATRIX
)
endif()

if(enable_decoder_aztec)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/aztec/AztecDetectorResult.cpp QZXing/zxing/zxing/aztec/AztecDetectorResult.h
        QZXing/zxing/zxing/aztec/AztecReader.cpp QZXing/zxing/zxing/aztec/AztecReader.h
        QZXing/zxing/zxing/aztec/decoder/AztecDecoder.cpp
        QZXing/zxing/zxing/aztec/decoder/Decoder.h
        QZXing/zxing/zxing/aztec/detector/AztecDetector.cpp
        QZXing/zxing/zxing/aztec/detector/Detector.h
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_DECODER_AZTEC
)
endif()

if(enable_decoder_pdf17)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/pdf417/PDF417Reader.cpp QZXing/zxing/zxing/pdf417/PDF417Reader.h
        QZXing/zxing/zxing/pdf417/decoder/BitMatrixParser.h
        QZXing/zxing/zxing/pdf417/decoder/DecodedBitStreamParser.h
        QZXing/zxing/zxing/pdf417/decoder/Decoder.h
        QZXing/zxing/zxing/pdf417/decoder/PDF417BitMatrixParser.cpp
        QZXing/zxing/zxing/pdf417/decoder/PDF417DecodedBitStreamParser.cpp
        QZXing/zxing/zxing/pdf417/decoder/PDF417Decoder.cpp
        QZXing/zxing/zxing/pdf417/decoder/ec/ErrorCorrection.cpp QZXing/zxing/zxing/pdf417/decoder/ec/ErrorCorrection.h
        QZXing/zxing/zxing/pdf417/decoder/ec/ModulusGF.cpp QZXing/zxing/zxing/pdf417/decoder/ec/ModulusGF.h
        QZXing/zxing/zxing/pdf417/decoder/ec/ModulusPoly.cpp QZXing/zxing/zxing/pdf417/decoder/ec/ModulusPoly.h
        QZXing/zxing/zxing/pdf417/detector/Detector.h
        QZXing/zxing/zxing/pdf417/detector/LinesSampler.cpp QZXing/zxing/zxing/pdf417/detector/LinesSampler.h
        QZXing/zxing/zxing/pdf417/detector/PDF417Detector.cpp
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_DECODER_PDF17
)
endif()

if(enable_generic_qrcode)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/qrcode/ErrorCorrectionLevel.h
        QZXing/zxing/zxing/qrcode/FormatInformation.h
        QZXing/zxing/zxing/qrcode/QRCodeReader.h
        QZXing/zxing/zxing/qrcode/QRErrorCorrectionLevel.cpp
        QZXing/zxing/zxing/qrcode/QRFormatInformation.cpp
        QZXing/zxing/zxing/qrcode/QRVersion.cpp
        QZXing/zxing/zxing/qrcode/Version.h
        QZXing/zxing/zxing/qrcode/decoder/Mode.h
        QZXing/zxing/zxing/qrcode/decoder/QRMode.cpp
    )
endif()

if(enable_encoder_generic)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/zxing/EncodeHint.cpp QZXing/zxing/zxing/EncodeHint.h
        QZXing/zxing/zxing/UnsupportedEncodingException.cpp QZXing/zxing/zxing/UnsupportedEncodingException.h
        QZXing/zxing/zxing/common/reedsolomon/ReedSolomonEncoder.cpp QZXing/zxing/zxing/common/reedsolomon/ReedSolomonEncoder.h
    )

target_compile_definitions(Ladeklubben PRIVATE
    ENABLE_ENCODER_GENERIC
)
endif()

if(qzxing_multimedia)
    target_compile_definitions(Ladeklubben PRIVATE
        QZXING_MULTIMEDIA
    )

target_link_libraries(Ladeklubben PRIVATE
    Qt::Multimedia
)
endif()

if((qzxing_multimedia) AND ((QT_VERSION VERSION_LESS 6.2)))
    target_sources(Ladeklubben PUBLIC
        QZXing/QZXingFilter.cpp QZXing/QZXingFilter.h
    )
endif()

if((qzxing_multimedia) AND ((QT_VERSION VERSION_GREATER 6.1)))
    target_sources(Ladeklubben PUBLIC
        QZXing/QZXingFilterVideoSink.cpp QZXing/QZXingFilterVideoSink.h
    )

target_link_libraries(Ladeklubben PRIVATE
    Qt::Concurrent
)
endif()

if(qzxing_qml)
    target_sources(Ladeklubben PUBLIC
        QZXing/QZXingImageProvider.cpp QZXing/QZXingImageProvider.h
    )

target_compile_definitions(Ladeklubben PRIVATE
    QZXING_QML
)
endif()

if((qzxing_qml) AND ((QT_VERSION VERSION_GREATER 4.7) AND (QT_VERSION VERSION_LESS 5.0)))
    target_link_libraries(Ladeklubben PRIVATE
        declarative
    )
endif()

if((qzxing_qml) AND ((QT_VERSION_MAJOR GREATER 4)))
    target_link_libraries(Ladeklubben PRIVATE
        Qt::Quick
    )
endif()

if(UNIX)
    target_compile_definitions(Ladeklubben PRIVATE
        NOFMAXL
        NO_ICONV
    )
endif()

if(CONFIG___contains___ubports AND UNIX)
    target_compile_definitions(Ladeklubben PRIVATE
        Q_OS_UBUNTUTOUCH
    )
endif()

if(CONFIG___contains___sailfishapp AND UNIX)
    target_compile_definitions(Ladeklubben PRIVATE
        Q_OS_SAILFISH
    )
endif()

if(win32-msvc_x_)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/win32/zxing/iconv.h
        QZXing/zxing/win32/zxing/msvc/stdint.h
        QZXing/zxing/win32/zxing/win_iconv.c
    )

target_include_directories(Ladeklubben PRIVATE
    QZXing/zxing/win32/zxing
    QZXing/zxing/win32/zxing/msvc
)

target_compile_definitions(Ladeklubben PRIVATE
    __STDC_LIMIT_MACROS
)
endif()

if(win32-g++)
    target_sources(Ladeklubben PUBLIC
        QZXing/zxing/win32/zxing/iconv.h
        QZXing/zxing/win32/zxing/win_iconv.c
    )

target_include_directories(Ladeklubben PRIVATE
    QZXing/zxing/win32/zxing
)
endif()

if(WINRT)
    target_compile_definitions(Ladeklubben PRIVATE
        NO_ICONV
    )
endif()

install(TARGETS Ladeklubben
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    #lib
)

# qt_generate_deploy_app_script(
#     TARGET Ladeklubben
#     FILENAME_VARIABLE deploy_script
#     NO_UNSUPPORTED_PLATFORM_ERROR
# )
#if(IOS)
qt_generate_deploy_qml_app_script(
    TARGET Ladeklubben
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
#else()
#     qt_generate_deploy_app_script(
#         TARGET Ladeklubben
#         FILENAME_VARIABLE deploy_script
#         NO_UNSUPPORTED_PLATFORM_ERROR
#     )
# endif()


install(SCRIPT ${deploy_script})
if (ANDROID)
    include(/home/omn/Android/Sdk/android_openssl/CMakeLists.txt)
endif()
