LOCAL_PATH:= $(call my-dir)

$(shell mkdir -p $(TARGET_OUT_APPS)/webview/lib/arm)
$(shell ln -sf $(TARGET_OUT)/lib/libwebviewchromium.so $(TARGET_OUT_APPS)/webview/lib/arm/libwebviewchromium.so)

$(shell mkdir -p $(TARGET_OUT_APPS)/webview/lib/arm64)
$(shell ln -sf $(TARGET_OUT)/lib64/libwebviewchromium.so $(TARGET_OUT_APPS)/webview/lib/arm64/libwebviewchromium.so)