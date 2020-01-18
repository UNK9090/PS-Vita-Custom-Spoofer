TITLE_ID = NANDMP001
PSVITAIP = 192.168.137.84

PLUGIN_OBJS = spoofer.o
HEADERS = $(wildcard *.h)

PLUGIN_LIBS =  -ltaihenForKernel_stub -Llibtaihen_stub.a -lSceSysclibForDriver_stub -lSceModulemgrForKernel_stub -lSceIofilemgrForDriver_stub -lSceModulemgrForKernel_stub -lSceLibc_stub -lSceSysmemForDriver_stub -lSceSblSsMgrForDriver_stub -lSceIdStorageForDriver_stub -lSceSblAuthMgrForKernel_stub -lSceThreadmgrForDriver_stub -lSceSysmemForKernel_stub -lSceSysmemForDriver_stub


PREFIX  = arm-vita-eabi
CC      = $(PREFIX)-gcc
CFLAGS  = -Wl,-q -Wall -O3
ASFLAGS = $(CFLAGS)

all: spoofer.skprx

spoofer.skprx: spoofer.velf
	vita-make-fself -c $< $@

spoofer.velf: spoofer.elf
	vita-elf-create -e exports.yml $< $@

spoofer.elf: $(PLUGIN_OBJS)
	$(CC) $(CFLAGS) $^ $(PLUGIN_LIBS) -o $@ -nostdlib

clean:
	@rm -rf *.velf *.elf *.vpk *.skprx $(MAIN_OBJS) $(PLUGIN_OBJS) param.sfo eboot.bin

send: eboot.bin
	curl -T spoofer.skprx ftp://$(PSVITAIP):1337/ux0:/tai/
	@echo "Sent."
