TARGET := iphone:clang:latest:14.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MCLoginFix
MCLoginFix_FILES := Tweak.x
MCLoginFix_CFLAGS := -fobjc-arc
MCLoginFix_FRAMEWORKS := UIKit SafariServices

include $(THEOS)/makefiles/tweak.mk
