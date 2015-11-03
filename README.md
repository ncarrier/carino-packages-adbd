# Linux only port of the adbd daemon

## Overview

This git repository provides an adaptation to the *Android Debug Bridge daemon*,
in order to be used on linux only platforms. Only the sctrictly needed
modifications have been made to provide base functionality of adbd (on target)
and proper interaction with adb (client, on host). Some functionalities shoudn't
work though, but could be "repaired" by further patching the original code.  

## How it works

The added code, in the *carino adbd* project is mainly the reimplementation of
the properties system with a configuration file and stubs of (considered as...)
non useful functions, in the frame of the carino project.

## How to build it standalone

        git clone https://github.com/ncarrier/carino-packages-adbd.git adbd_main
        git clone https://github.com/ncarrier/aosp-platform-system-core adbd_core
        git clone https://github.com/ncarrier/aosp-platform-system-extras adbd_extras
        mkdir build
        cd build
        make -f ../adbd_main/Makefile VPATH=..

Will produce the *adbd* executable, which must be ran as root.

## License

### For the adbd/core and adbd/extras

These softwares are provided with little, if any patches, with the full git
history of the upstream project (aosp). The original license informations are
provided in the source trees, left untouched.  
These projects are released under an Apache 2 license, please refer to their
copyright notices for more information.

### For this README.md file

    This file is part of the Carino project documentation.
    Copyright (C) 2015
      Nicolas CARRIER <carrier dot nicolas0 at gmail dot com>
    See the file doc/README.md for copying conditions

