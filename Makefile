VPATH := ../packages/adbd/

CPPFLAGS := $(CPPFLAGS) \
	-DADB_HOST=0 -DHAVE_FORKEXEC \
	-DHAVE_SYMLINKS -D_XOPEN_SOURCE -D_GNU_SOURCE \
	-DPROP_VALUE_MAX=92 \
	-DPROP_NAME_MAX=32 \
	-Dnullptr=NULL \
	-I $(VPATH)core/adb \
	-I $(VPATH)core/fs_mgr/include/ \
	-I $(VPATH)core/include/ \
	-I $(VPATH)extras/ext4_utils/

CXXFLAGS := $(CXXFLAGS) \
	-fpermissive

LDFLAGS := $(LDFLAGS) \
	-pthread \
	-lrt

CXX_OBJS := core/adb/fdevent.cpp.o
C_OBJS := \
	compat_and_stubs.c.o \
	b64_pton.c.o \
	core/adb/adb.c.o \
	core/adb/adb_auth_client.c.o \
	core/adb/jdwp_service.c.o \
	core/adb/framebuffer_service.c.o \
	core/adb/file_sync_service.c.o \
	core/adb/remount_service.c.o \
	core/adb/set_verity_enable_state_service.c.o \
	core/adb/services.c.o \
	core/adb/sockets.c.o \
	core/adb/transport.c.o \
	core/adb/transport_local.c.o \
	core/adb/transport_usb.c.o \
	core/adb/usb_linux.c.o \
	core/fs_mgr/fs_mgr_fstab.c.o \
	core/libbacktrace/thread_utils.c.o \
	core/libcutils/klog.c.o \
	core/libcutils/socket_inaddr_any_server.c.o \
	core/libcutils/socket_loopback_server.c.o \
	core/libcutils/socket_loopback_client.c.o \
	core/libcutils/socket_local_client.c.o \
	core/libcutils/socket_local_server.c.o \
	core/liblog/logd_write.c.o \
	core/libmincrypt/rsa.c.o \
	core/libmincrypt/sha.c.o \
	core/libmincrypt/sha256.c.o \
	extras/ext4_utils/ext4_sb.c.o

%.cpp.o:%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $^ -c -o $@

%.c.o:%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -c -o $@

adbd: $(CXX_OBJS) $(C_OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS)
