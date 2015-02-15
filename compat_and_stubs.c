/**
 * @file compat_and_stubs.c
 * @brief 
 *
 * @date 14 févr. 2015
 * @author carrier.nicolas0@gmail.com
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include <cutils/properties.h>

#define DEFAULT_CONF_FILE_PATH "/etc/adb.conf"
#define BUF_SIZE 0x400

#define CONF_FILE_PATH_ENV_VAR "ADBD_CONF_FILE_PATH"

static const bool debug = false;

static const char *conf_file_path = DEFAULT_CONF_FILE_PATH;

static void __attribute__((constructor)) init_compat_and_stubs(void)
{
	const char *env_value;

	env_value = getenv(CONF_FILE_PATH_ENV_VAR);
	if (env_value != NULL)
		conf_file_path = env_value;
}

int property_set(const char *key, const char *value)
{
	if (debug)
		fprintf(stderr, "%s(%s, %s) stub !!!\n", __func__, key, value);
	return -1; // TODO
}

void pfclose(FILE **f)
{
	if (f == NULL || *f == NULL)
		return;
	fclose(*f);
	*f = NULL;
}

int property_get(const char *key, char *value, const char *default_value)
{
	FILE __attribute__((cleanup(pfclose)))*conf_file = NULL;
	char *line;
	char buf[BUF_SIZE];
	size_t len;
	size_t i;

	if (value == NULL)
		return -1;
	value[0] = '\0';
	if (key == NULL)
		return -1;

	conf_file = fopen(conf_file_path, "rbe");
	if (conf_file == NULL) {
		if (debug)
			fprintf(stderr, "%s(\"%s\", %p, \"%s\") fopen failed\n",
					__func__, key, value, default_value);
		if (default_value != NULL) {
			strncpy(value, default_value, PROPERTY_VALUE_MAX);
			value[PROPERTY_VALUE_MAX - 1] = '\0';
		}
		return -1;
	}

	while ((line = fgets(buf, BUF_SIZE, conf_file)) != NULL) {
		len = strlen(key);
		if (strncmp(line, key, len) != 0 || line[len] != '=')
			continue;

		strncpy(value, line + len + 1, PROPERTY_VALUE_MAX);
		i = strlen(value);
		while (i--)
			if (isspace(value[i]))
				value[i] = '\0';
			else
				break;
		value[PROPERTY_VALUE_MAX - 1] = '\0';
	}

	if (default_value != NULL) {
		if (value[0] == '\0') {
			/* not found, fill in the default_value */
			strncpy(value, default_value, PROPERTY_VALUE_MAX);
			value[PROPERTY_VALUE_MAX - 1] = '\0';
		}
		if (debug)
			fprintf(stderr, "%s(\"%s\", \"%s\", \"%s\")\n",
					__func__, key, value, default_value);
	} else {
		if (debug)
			fprintf(stderr, "%s(\"%s\", \"%s\", NULL)\n", __func__,
					key, value);
	}

	return 0;
}

int is_selinux_enabled(void)
{
	if (debug)
		fprintf(stderr, "%s() stub !!!\n", __func__);
	return 0;
}

int setcon(const char *unused)
{
	if (debug)
		fprintf(stderr, "%s(%s) stub !!!\n", __func__, unused);
	return -1;
}

void selinux_android_restorecon(const char *foo, int bar)
{
	if (debug)
		fprintf(stderr, "%s(%s, %s) stub !!!\n", __func__, foo, bar);
}
