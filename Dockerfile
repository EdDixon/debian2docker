FROM debian:jessie
MAINTAINER unclejack
ENV LB /root/lb
RUN apt-get update;\
  apt-get install -y apt-utils live-build bzip2 lzma xz-utils squashfs-tools wget ca-certificates
RUN mkdir $LB ;\
 cd $LB ; \
 lb config --initramfs-compression lzma --compression xz -d jessie \
 --debian-installer false --apt-indices false --apt-recommends false \
 --debootstrap-options "--variant=minbase"  --firmware-chroot false \
 --mirror-bootstrap http://http.debian.net/debian/ \
 --memtest none --zsync false live
RUN cp /usr/share/doc/live-build/examples/hooks/stripped.chroot $LB/config/hooks/
RUN sed -i 's/rm -rf \/usr\/share\/zoneinfo\/\*//g' $LB/config/hooks/stripped.chroot
ADD hooks/ $LB/config/hooks/
ADD reqs.list.chroot $LB/config/package-lists/
ADD includes.binary/ $LB/config/includes.binary/
ADD includes.chroot/ $LB/config/includes.chroot/
ADD VERSION $LB/config/includes.binary/version
RUN cp $LB/config/includes.binary/version $LB/config/includes.chroot/etc/debian2docker-version
RUN echo "boot\ninitrd.img\nvmlinuz" > $LB/config/rootfs/excludes
WORKDIR /root/lb
CMD ["lb", "build"]
