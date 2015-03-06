VPATH := ../packages/adbd/

CPPFLAGS := $(CPPFLAGS) \
	-DADB_LINUX=1 \
	-DADB_HOST=0 -DHAVE_FORKEXEC \
	-DHAVE_SYMLINKS -D_XOPEN_SOURCE -D_GNU_SOURCE \
	-DPROP_VALUE_MAX=92 \
	-DPROP_NAME_MAX=32 \
	-Dnullptr=NULL \
	-DALLOW_ADBD_ROOT=1 \
	-I $(VPATH)../adbd_core/adb \
	-I $(VPATH)../adbd_core/fs_mgr/include/ \
	-I $(VPATH)../adbd_core/include/ \
	-I $(VPATH)../adbd_extras/ext4_utils/

CXXFLAGS := $(CXXFLAGS) \
	-fpermissive

LDFLAGS := $(LDFLAGS) \
	-pthread \
	-lrt

CXX_OBJS := ../adbd_core/adb/fdevent.cpp.o
C_OBJS := \
	compat_and_stubs.c.o \
	b64_pton.c.o \
	../adbd_core/adb/adb.c.o \
	../adbd_core/adb/adb_auth_client.c.o \
	../adbd_core/adb/jdwp_service.c.o \
	../adbd_core/adb/framebuffer_service.c.o \
	../adbd_core/adb/file_sync_service.c.o \
	../adbd_core/adb/remount_service.c.o \
	../adbd_core/adb/set_verity_enable_state_service.c.o \
	../adbd_core/adb/services.c.o \
	../adbd_core/adb/sockets.c.o \
	../adbd_core/adb/transport.c.o \
	../adbd_core/adb/transport_local.c.o \
	../adbd_core/adb/transport_usb.c.o \
	../adbd_core/adb/usb_linux.c.o \
	../adbd_core/fs_mgr/fs_mgr_fstab.c.o \
	../adbd_core/libbacktrace/thread_utils.c.o \
	../adbd_core/libcutils/klog.c.o \
	../adbd_core/libcutils/socket_inaddr_any_server.c.o \
	../adbd_core/libcutils/socket_loopback_server.c.o \
	../adbd_core/libcutils/socket_loopback_client.c.o \
	../adbd_core/libcutils/socket_local_client.c.o \
	../adbd_core/libcutils/socket_local_server.c.o \
	../adbd_core/liblog/logd_write.c.o \
	../adbd_core/libmincrypt/rsa.c.o \
	../adbd_core/libmincrypt/sha.c.o \
	../adbd_core/libmincrypt/sha256.c.o \
	../adbd_extras/ext4_utils/ext4_sb.c.o

%.cpp.o:%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $^ -c -o $@

%.c.o:%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -c -o $@

adbd: $(CXX_OBJS) $(C_OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS)
