PACKAGE=apt-transport-sftp
VERSION=0.2.1-xenial
FAKEROOT=./data-root
DOCDIR=$(FAKEROOT)/usr/share/doc/$(PACKAGE)/
LINTIANOVERRIDES=$(FAKEROOT)/usr/share/lintian/overrides/$(PACKAGE)
DEB=$(PACKAGE)_$(VERSION)_amd64.deb
METHODSDIR=$(FAKEROOT)/usr/lib/apt/methods
CONFDIR=$(FAKEROOT)/etc/apt/apt.conf.d

package: $(DEB)

signed-package: _gpgorigin $(DEB)
	ar r $(DEB) $<

_gpgorigin: $(DEB)
	-rm -f $@
	ar p $(DEB) debian-binary control.tar.gz data.tar.gz | gpg -abs -o _gpgorigin

$(DEB): tarballs debian-binary
	-rm -f $@
	ar rc $@ debian-binary control.tar.gz data.tar.gz
	lintian $@

$(DOCDIR):
	mkdir -p $@

$(DOCDIR)/changelog.Debian.gz: ../debian/changelog $(DOCDIR)
	cat $< | gzip -n -9 > $@

$(DOCDIR)/copyright: ../debian/copyright $(DOCDIR)
	cp $< $@

$(LINTIANOVERRIDES): lintian-overrides
	mkdir -p $(@D)
	cat $< | sed "s/PACKAGE/$(PACKAGE)/g" >$@
	
debian-binary:
	echo 2.0 > debian-binary

tarballs: data.tar.gz control.tar.gz

control.tar.gz: md5sums ../debian/control
	-rm -rf control-root
	-mkdir -p control-root	
	cp conffiles ../debian/control md5sums control-root
	chmod 644 control-root/*
	sed -i '/^Version:/c Version: $(VERSION)' control-root/control
	sed -i '/^Package:/c Package: $(PACKAGE)' control-root/control
	cd control-root && tar -czf ../$@ --owner=root --group=root .

md5sums: install-deps
	(cd $(FAKEROOT) && md5sum `find -type f`) > $@
	chmod 0644 $@

data.tar.gz: install-deps \
             $(DOCDIR)/changelog.Debian.gz \
             $(DOCDIR)/copyright \
			 $(LINTIANOVERRIDES)
	find $(FAKEROOT) -type d | xargs chmod 0755
	find $(FAKEROOT) -type d | xargs chmod ug-s
	find $(FAKEROOT)/usr/share/doc -type f | xargs chmod 0644
	cd $(FAKEROOT) && tar -czf ../$@ --owner=root --group=root --mode=go-w *

.PHONY: clean install-clean install-deps

clean: install-clean
	-rm -rf control-root
	-rm -f debian-binary *.tar.gz _gpgorigin md5sums
	-rm -f lib*.deb

install-clean:
	-rm -rf $(FAKEROOT)

install-deps: install-clean	
	mkdir -p $(METHODSDIR) $(CONFDIR)
	install -m 755 ../sftp $(METHODSDIR)
	strip $(METHODSDIR)/sftp
	install -m 644 ../doc/30sftp.ex $(CONFDIR)/30sftp