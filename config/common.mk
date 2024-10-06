# Allow vendor/extra to override any property by setting it first
$(call inherit-product, vendor/pixys/build/core/pixys_version.mk)

PRODUCT_BRAND ?= PixysOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/pixys/prebuilt/common/etc/adblock/init.adblock.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.adblock.rc

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/pixys/config/permissions/pixys-power-whitelist.xml:system/etc/sysconfig/pixys-power-whitelist.xml

# Charger
PRODUCT_PACKAGES += \
    product_charger_res_images

# Copy all Pixys-specific init rc files
$(foreach f,$(wildcard vendor/pixys/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/pixys/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Pixys permissions
PRODUCT_COPY_FILES += \
    vendor/pixys/config/permissions/privapp-permissions-pixys-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-pixys.xml \
    vendor/pixys/config/permissions/privapp-permissions-pixys-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-pixys-product.xml

# Log privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Inherit Pixys audio files
$(call inherit-product, vendor/pixys/config/pixys_audio.mk)

# Inherit Pixys extra packages
$(call inherit-product, vendor/pixys/config/pixys_packages.mk)

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
$(call inherit-product, vendor/pixys/bootanimation/bootanimation.mk)

# Fonts
$(call inherit-product, vendor/pixys/config/fonts.mk)

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Pixel customization
TARGET_SUPPORTS_GOOGLE_BATTERY ?= false

# faceunlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)

PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/pixys/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/pixys/overlay/common

# rro_overlays
$(call inherit-product, vendor/pixys/config/rro_overlays.mk)

# pixys prebuilts
$(call inherit-product, vendor/pixys-prebuilts/config.mk)

# Certification
$(call inherit-product-if-exists, vendor/certification/config.mk)

# Inherit art options
include vendor/pixys/config/art.mk

# Pixel Framework
#$(call inherit-product, vendor/pixel-framework/config.mk)


-include $(WORKSPACE)/build_env/image-auto-bits.mk

# Inherit from apex config
$(call inherit-product, vendor/pixys/config/apex.mk)
