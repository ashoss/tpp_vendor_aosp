CUSTOM_DATE_YEAR := $(shell date -u +%Y)
CUSTOM_DATE_MONTH := $(shell date -u +%m)
CUSTOM_DATE_DAY := $(shell date -u +%d)
CUSTOM_DATE_HOUR := $(shell date -u +%H)
CUSTOM_DATE_MINUTE := $(shell date -u +%M)
CUSTOM_BUILD_DATE := $(CUSTOM_DATE_YEAR)$(CUSTOM_DATE_MONTH)$(CUSTOM_DATE_DAY)

# Signing
ifeq ($(IS_SIGNED),true)
-include vendor/lineage-priv/keys/keys.mk
endif

CUSTOM_PLATFORM_VERSION := 15.0
CUSTOM_DISPLAY_VERSION := 1.0

CUSTOM_BUILDTYPE ?= UNOFFICIAL

CUSTOM_SHOW_VERSION := $(CUSTOM_BUILD)-$(CUSTOM_DISPLAY_VERSION)-$(CUSTOM_BUILD_DATE)

CUSTOM_VERSION := tpp_$(CUSTOM_PLATFORM_VERSION)-$(CUSTOM_BUILD)-$(CUSTOM_BUILDTYPE)-$(CUSTOM_BUILD_DATE)$(if $(IS_SIGNED),-signed)
CUSTOM_VERSION_PROP := fifteen

PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.build.date=$(CUSTOM_BUILD_DATE) \
    ro.custom.build.version=$(CUSTOM_DISPLAY_VERSION) \
    ro.custom.device=$(CUSTOM_BUILD) \
    ro.custom.fingerprint=$(ROM_FINGERPRINT) \
    ro.custom.releasetype=$(CUSTOM_BUILDTYPE) \
    ro.custom.showversion=$(CUSTOM_SHOW_VERSION) \
    ro.custom.version=$(CUSTOM_VERSION) \
    ro.modversion=$(CUSTOM_VERSION)
