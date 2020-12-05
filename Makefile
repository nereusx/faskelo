PERF=perf stat -e cycles -r 50

all: nasm-output.txt gcc-output.txt fpc-output.txt fas.class

fas-nasm: fas.asm
	nasm -f elf64 -o fas.o fas.asm
	ld -o fas-nasm fas.o

nasm-output.txt: fas-nasm
	objdump -M intel -d fas-nasm > nasm-output.txt

fas-gcc: fas.c
	gcc -O fas.c -o fas-gcc

gcc-output.txt: fas-gcc nasm-output.txt
	gcc -O -S -masm=intel fas.c -o gcc-output.txt

fas-fpc: fas.pas
	fpc fas.pas
	mv fas fas-fpc

fpc-output.txt: fas-fpc gcc-output.txt
	fpc -a -Anasm fas.pas
	mv fas.s fpc-output.txt

fas-rs: fas.rs
	rustc -O fas.rs -o fas-rs

fas.class: fas.java
	javac fas.java

perf: fas-rs fas-gcc fas-fpc fas-nasm fas.class
	@echo -n "=== x86 assembly    "
	@$(PERF) ./fas-nasm 2>&1 | grep cycles
	@echo -n "=== gnu C           "
	@$(PERF) ./fas-gcc  2>&1 | grep cycles
	@echo -n "=== free pascal     "
	@$(PERF) ./fas-fpc  2>&1 | grep cycles
	@echo -n "=== rust            "
	@$(PERF) ./fas-rs  2>&1 | grep cycles
	@echo -n "=== shell (dash)    "
	@$(PERF) ./fas.sh   2>&1 | grep cycles
	@echo -n "=== awk             "
	@$(PERF) ./fas.awk  2>&1 | grep cycles
	@echo -n "=== BASIC (yabasic) "
	@$(PERF) ./fas.bas  2>&1 | grep cycles
	@echo -n "=== perl            "
	@$(PERF) ./fas.pl  2>&1  | grep cycles
	@echo -n "=== php             "
	@$(PERF) ./fas.php  2>&1 | grep cycles
	@echo -n "=== python3         "
	@$(PERF) ./fas.py   2>&1 | grep cycles
	@echo -n "=== java            "
	@$(PERF) java fas   2>&1 | grep cycles

clean:
	-rm -f fas fas.{s,o,so,class} *-output.txt fas-{nasm,gcc,fpc,rs} a.out
