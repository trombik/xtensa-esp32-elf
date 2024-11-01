PORTNAME=	riscv32-esp-elf
COMMENT=	Espressif ESP32 toolchain for RISC-V-based MCUs
FLAVORS=	idf54 idf53 idf52 idf51 idf50
FLAVOR?=	${FLAVORS:[1]}

.if ${FLAVOR} == idf53 || ${FLAVOR} == idf54
MASTERDIR=	${.CURDIR}/../xtensa-esp-elf
.else
MASTERDIR=	${.CURDIR}/../xtensa-esp32-elf-legacy
.endif

.include "${MASTERDIR}/Makefile"
