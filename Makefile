# NetLogo.jar files are now modefied by the NetLogo version number,
# e.g., netlogo-6.0.1.jar. Maker sure NLVERSION is set to the right
# version number.
NLVERSION=6.0.1

ifeq ($(origin JAVA_HOME), undefined)
  JAVA_HOME=/usr
endif

ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

JAVAC="$(JAVA_HOME)/bin/javac"
SRCS=$(wildcard src/*.java)

shell.zip: shell.jar shell.jar.pack.gz README.md Makefile src ShellTest manifest.txt
	-rm -rf shell
	mkdir shell
	cp -rp shell.jar shell.jar.pack.gz README.md Makefile manifest.txt src ShellTest shell
	zip -rv shell.zip shell
	rm -rf shell

shell.jar shell.jar.pack.gz: $(SRCS) manifest.txt Makefile
	-rm -rf classes
	mkdir classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.8 -target 1.8 -classpath $(NETLOGO)/netLogo-$(NLVERSION).jar -d classes $(SRCS)
	jar cmf manifest.txt shell.jar -C classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip shell.jar.pack.gz shell.jar
	-rm -rf classes
