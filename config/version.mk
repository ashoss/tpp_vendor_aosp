CUSTOM_BUILD_DATE := $(shell date -u +%Y%m%d-%H%M)

# Signing
ifeq ($(IS_SIGNED),true)
-include vendor/lineage-priv/keys/keys.mk
endif

CUSTOM_INCREMENTAL := .1

CUSTOM_PLATFORM_VERSION := 15

CUSTOM_BUILDTYPE ?= UNOFFICIAL

CUSTOM_SHOW_VERSION := $(CUSTOM_BUILD)-$(CUSTOM_DISPLAY_VERSION)-$(CUSTOM_BUILD_DATE)

CUSTOM_VERSION := tpp_$(CUSTOM_PLATFORM_VERSION)$(CUSTOM_INCREMENTAL)-$(CUSTOM_BUILD)-$(CUSTOM_BUILDTYPE)-$(CUSTOM_BUILD_DATE)$(if $(IS_SIGNED),-signed)
CUSTOM_VERSION_PROP := fifteen

PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.build.date=$(CUSTOM_BUILD_DATE) \
    ro.custom.build.version=$(CUSTOM_DISPLAY_VERSION) \
    ro.custom.device=$(CUSTOM_BUILD) \
    ro.custom.fingerprint=$(ROM_FINGERPRINT) \
    ro.custom.maintainer=$(CUSTOM_MAINTAINER) \
    ro.custom.releasetype=$(CUSTOM_BUILDTYPE) \
    ro.custom.showversion=$(CUSTOM_SHOW_VERSION) \
    ro.custom.version=$(CUSTOM_VERSION) \
    ro.modversion=$(CUSTOM_VERSION)
