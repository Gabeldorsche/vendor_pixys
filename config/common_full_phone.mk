# Inherit full common PixysOS stuff
$(call inherit-product, vendor/pixys/config/common.mk)

# Inherit apns
$(call inherit-product, vendor/pixys/config/telephony.mk)
