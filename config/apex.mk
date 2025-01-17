#
# Copyright (C) 2024 The hentaiOS Project and its Proprietors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# FIXME -- Profiling prebuilts is only planned to be released for AP41
DISABLE_DEXPREOPT_CHECK := true

# If true, this builds the mainline modules from source. This overrides any
# prebuilts selected via RELEASE_APEX_CONTRIBUTIONS_* build flags for the
# current release config.
PRODUCT_MODULE_BUILD_FROM_SOURCE ?= false

# Setup build characteristics
PRODUCT_INCLUDE_TAGS := com.android.mainline mainline_module_prebuilt_monthly_release

# Optional ART/BT/UWB/WIFI module
MAINLINE_INCLUDE_ART_MODULE ?= true
MAINLINE_INCLUDE_BT_MODULE ?= true
MAINLINE_INCLUDE_UWB_MODULE ?= true
MAINLINE_INCLUDE_WIFI_MODULE ?= true

# Networkstack certificate
PRODUCT_MAINLINE_SEPOLICY_DEV_CERTIFICATES=vendor/pixys/apex/certificates

SOONG_CONFIG_NAMESPACES += wifi_module
SOONG_CONFIG_wifi_module += source_build
SOONG_CONFIG_wifi_module_source_build := true

SOONG_CONFIG_NAMESPACES += uwb_module
SOONG_CONFIG_uwb_module += source_build
SOONG_CONFIG_uwb_module_source_build := true

SOONG_CONFIG_NAMESPACES += bluetooth_module
SOONG_CONFIG_bluetooth_module += source_build
SOONG_CONFIG_bluetooth_module_source_build := true

ifneq ($(MAINLINE_INCLUDE_ART_MODULE),true)
ART_MODULE_BUILD_FROM_SOURCE := false
endif

ifeq ($(MAINLINE_INCLUDE_BT_MODULE),true)
SOONG_CONFIG_bluetooth_module_source_build := false
endif

ifeq ($(MAINLINE_INCLUDE_UWB_MODULE),true)
SOONG_CONFIG_uwb_module_source_build := false
endif

ifeq ($(MAINLINE_INCLUDE_WIFI_MODULE),true)
SOONG_CONFIG_wifi_module_source_build := false
endif

# Enable Google Play system updates support
PRODUCT_SOONG_NAMESPACES += \
    vendor/pixys/apex

# ModuleMetadata
PRODUCT_PACKAGES += \
    ModuleMetadataGoogle

# Google Apexes
PRODUCT_PACKAGES += \
	com.google.android.adbd \
	com.google.android.adservices \
	com.google.android.appsearch \
	com.google.android.cellbroadcast \
	com.google.android.configinfrastructure \
	com.google.android.conscrypt \
	com.google.android.devicelock \
	com.google.android.extservices \
	com.google.android.healthfitness \
	com.google.android.ipsec \
	com.google.android.media \
	com.google.android.media.swcodec \
	com.google.android.mediaprovider \
	com.google.android.neuralnetworks \
	com.google.android.nfcservices \
	com.google.android.ondevicepersonalization \
	com.google.android.os.statsd \
	com.google.android.permission \
	com.google.android.profiling \
	com.google.android.resolv \
	com.google.android.rkpd \
	com.google.android.scheduling \
	com.google.android.sdkext \
	com.google.android.tethering \
	com.google.android.tzdata6 \
	com.google.mainline.primary.libs
