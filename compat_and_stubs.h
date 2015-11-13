#ifndef _COMPAT_AND_STUBS
#define _COMPAT_AND_STUBS
int is_selinux_enabled(void);
int setcon(const char *unused);
void selinux_android_restorecon(const char *foo, int bar);
#endif /* _COMPAT_AND_STUBS */
