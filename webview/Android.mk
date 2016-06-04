LOCAL_PATH:= $(call my-dir)
ifeq ($(PRODUCT_PREBUILT_WEBVIEWCHROMIUM),yes)

ZPATH := $(LOCAL_PATH)

#include $(ZPATH)/libwebviewchromium/Android.mk
#include $(ZPATH)/libwebviewchromium_loader/Android.mk
#include $(ZPATH)/libwebviewchromium_plat_support/Android.mk

$(shell cp $(ZPATH)/arm/libwebviewchromium.so              $(TARGET_OUT)/lib)
$(shell cp $(ZPATH)/arm/libwebviewchromium_loader.so       $(TARGET_OUT)/lib)
$(shell cp $(ZPATH)/arm/libwebviewchromium_plat_support.so $(TARGET_OUT)/lib)

$(shell cp $(ZPATH)/arm64/libwebviewchromium.so              $(TARGET_OUT)/lib64)
$(shell cp $(ZPATH)/arm64/libwebviewchromium_loader.so       $(TARGET_OUT)/lib64)
$(shell cp $(ZPATH)/arm64/libwebviewchromium_plat_support.so $(TARGET_OUT)/lib64)

include $(ZPATH)/webview/Android.mk

include $(ZPATH)/postbuild/Android.mk

endif
