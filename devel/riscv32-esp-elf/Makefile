PORTNAME=	riscv32-esp-elf
COMMENT=	Espressif ESP32 toolchain for RISC-V-based MCUs
FLAVORS=	idf53 idf52 idf51 idf50
FLAVOR?=	${FLAVORS:[1]}

.if ${FLAVOR} == idf53
MASTERDIR=	${.CURDIR}/../xtensa-esp-elf
.else
MASTERDIR=	${.CURDIR}/../xtensa-esp32-elf
.endif

.include "${MASTERDIR}/Makefile"
