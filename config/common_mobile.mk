# Inherit common mobile stuff
$(call inherit-product, vendor/aosp/config/common.mk)

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Aperture
ifneq ($(PRODUCT_NO_CAMERA),true)
PRODUCT_PACKAGES += \
    Aperture
endif

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
