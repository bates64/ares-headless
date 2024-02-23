name := ares
build := optimized
threaded := true
openmp := false
vulkan := true
sdl2 := true
local := true
lto := false
flags += -I. -I.. -I../ares -I../thirdparty -DMIA_LIBRARY

nall.path := ../nall
include $(nall.path)/GNUmakefile

ifneq ($(filter $(arch),x86 amd64),)
  ifeq ($(filter cl,$(compiler)),)
    ifeq ($(local),true)
      flags += -march=native
    else
      # For official builds, default to x86-64-v2 (Intel Nehalem, AMD Bulldozer) which supports up to SSE 4.2.
      flags += -march=x86-64-v2
    endif
  endif
endif

ifeq ($(platform),macos)
  ares.dylibs :=
endif

libco.path := ../libco
include $(libco.path)/GNUmakefile

thirdparty.path := ../thirdparty
sljit.path := $(thirdparty.path)/sljit/sljit_src
libchdr.path := $(thirdparty.path)/libchdr
tzxfile.path := $(thirdparty.path)/TZXFile
ymfm.path := $(thirdparty.path)/ymfm
include $(thirdparty.path)/GNUmakefile

ruby.path := ../ruby
include $(ruby.path)/GNUmakefile

hiro.path := ../hiro
hiro.resource := resource/ares.rc
include $(hiro.path)/GNUmakefile

profile := performance
#cores := a26 fc sfc n64 sg ms md ps1 pce ng msx cv myvision gb gba ws ngp spec
cores := n64
#cores += saturn

ares.path := ../ares
include $(ares.path)/GNUmakefile

mia.path := ../mia

mia.objects := mia mia-resource
mia.objects := $(mia.objects:%=$(object.path)/%.o)

$(object.path)/mia.o: $(mia.path)/mia.cpp
$(object.path)/mia-resource.o: $(mia.path)/resource/resource.cpp

all.objects :=            $(libco.objects) $(sljit.objects) $(libchdr.objects) $(tzxfile.objects) $(ymfm.objects) $(nall.objects) $(ares.objects) $(mia.objects)
all.options := $(options) $(libco.options) $(sljit.options) $(libchdr.options) $(tzxfile.options) $(ymfm.options) $(nall.options) $(ares.options) $(mia.options)

$(all.objects): | $(object.path)

ar := ar rc
extension := .a

all: $(all.objects) | $(output.path)
	$(info Linking $(output.path)/$(name)$(extension) ...)
	$(call lib_out,$(output.path)/$(name)$(extension))
	+@$(ar) $(output.path)/$(name)$(extension) $(all.objects)
	$(call copy,../LICENSE,$(output.path)/LICENSE.txt)
ifeq ($(platform),macos)
# Apply workaround for buggy linker in Xcode < 11.4.1
	@$(compiler) -o $(output.path)/macos-fix-jit macos-fix-jit.cpp
	$(output.path)/macos-fix-jit $(output.path)/$(name)
	rm -f $(output.path)/macos-fix-jit
	rm -rf $(output.path)/$(name).app
	install_name_tool -add_rpath @executable_path/../Frameworks $(output.path)/$(name)
	mkdir -p $(output.path)/$(name).app/Contents/MacOS/
	mkdir -p $(output.path)/$(name).app/Contents/Resources/
	mkdir -p $(output.path)/$(name).app/Contents/Frameworks/
ifneq ($(ares.dylibs),)
	cp $(ares.dylibs) $(output.path)/$(name).app/Contents/Frameworks/
endif
	mv $(output.path)/$(name) $(output.path)/$(name).app/Contents/MacOS/$(name)
	cp resource/$(name).plist $(output.path)/$(name).app/Contents/Info.plist
	cp -R $(ares.path)/Shaders $(output.path)/$(name).app/Contents/Resources/
	cp -R $(mia.path)/Database $(output.path)/$(name).app/Contents/Resources/	
	sips -s format icns resource/$(name).png --out $(output.path)/$(name).app/Contents/Resources/$(name).icns
	codesign --force --deep --options runtime --entitlements resource/$(name).selfsigned.entitlements --sign - $(output.path)/$(name).app
else ifeq ($(platform),windows)
	$(call mkdir,$(output.path)/Shaders/)
	$(call mkdir,$(output.path)/Database/)
	$(call rcopy,$(ares.path)/Shaders/*,$(output.path)/Shaders/)
	$(call rcopy,$(mia.path)/Database/*,$(output.path)/Database/)
endif

verbose: nall.verbose ruby.verbose hiro.verbose all;

clean:
ifeq ($(platform),macos)
	rm -rf $(output.path)/$(name).app
endif
	$(call rdelete,$(object.path))
	$(call rdelete,$(output.path))

# install: all
# ifeq ($(platform),windows)
# 	$(call mkdir,$(prefix)/$(name)/)
# else ifeq ($(shell id -un),root)
# 	$(error "make install should not be run as root")
# else ifeq ($(platform),macos)
# 	mkdir -p ~/Library/Application\ Support/$(name)/
# 	cp -R $(output.path)/$(name).app /Applications/$(name).app
# else ifneq ($(filter $(platform),linux bsd),)
# 	mkdir -p $(prefix)/bin/
# 	mkdir -p $(prefix)/share/applications/
# 	mkdir -p $(prefix)/share/icons/hicolor/256x256/apps/
# 	mkdir -p $(prefix)/share/$(name)/Shaders/
# 	mkdir -p $(prefix)/share/$(name)/Database/
# 	cp $(output.path)/$(name) $(prefix)/bin/$(name)
# 	cp -R $(ares.path)/Shaders/* $(prefix)/share/$(name)/Shaders/
# 	cp -R $(mia.path)/Database/* $(prefix)/share/$(name)/Database/
# 	cp resource/$(name).desktop $(prefix)/share/applications/$(name).desktop
# 	cp resource/$(name).png $(prefix)/share/icons/hicolor/256x256/apps/$(name).png
# endif

# uninstall:
# ifeq ($(platform),windows)
# else ifeq ($(shell id -un),root)
# 	$(error "make uninstall should not be run as root")
# else ifeq ($(platform),macos)
# 	rm -rf /Applications/$(name).app
# else ifneq ($(filter $(platform),linux bsd),)
# 	rm -f $(prefix)/bin/$(name)
# 	rm -f $(prefix)/share/applications/$(name).desktop
# 	rm -f $(prefix)/share/icons/hicolor/256x256/apps/$(name).png
# endif

-include $(object.path)/*.d
