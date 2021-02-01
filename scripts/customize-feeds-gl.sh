#!/bin/bash
# 修改主机名字
#sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +%Y%m%d)-sirpdboy-N18.06-/g' include/image.mk

# 内核显示增加自己个性名称
date1='S'`TZ=UTC-8 date +%Y.%m.%d -d +"0"days`
cp -f ./banner /workdir/openwrt/package/base-files/files/etc/
#sed -i '/DISTRIB_REVISION/d' /workdir/openwrt//package/base-files/files/etc/openwrt_release
#echo "DISTRIB_REVISION='${date1} by Siropboy'" > /workdir/openwrt//package/base-files/files/etc/openwrt_release1
echo "DISTRIB_REVISION='${date1} %R'" >> /workdir/openwrt/package/base-files/files/etc/openwrt_release
sed -i 's/$(VERSION_DIST_SANITIZED)/$(shell TZ=UTC-8 date +%Y%m%d)/g' /workdir/openwrt/include/image.mk

sed -i '/DISTRIB_DESCRIPTION/d' /workdir/openwrt//package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='OpenWrt %V by Siropboy %C'/g" /workdir/openwrt/package/base-files/files/etc/openwrt_release
sed -i "s/# REVISION:=x/REVISION:= $date1/g" /workdir/openwrt/include/version.mk

echo ${date1}' by Siropboy ' >> /workdir/openwrt//package/base-files/files/etc/banner
echo '---------------------------------' >> /workdir/openwrt/package/base-files/files/etc/banner
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /workdir/openwrt/package/base-files/files/etc/shadow

#mkdir -p /workdir/openwrt/package/lean

# Add luci-app-ssr-plus
#cd /workdir/openwrt/package/lean
git clone https://github.com/fw876/helloworld /workdir/openwrt/package/lean

cd /workdir/lede/package/lean
plist="shadowsocksr-libev pdnsd-alt microsocks dns2socks simple-obfs v2ray-plugin v2ray xray trojan ipt2socks redsocks2 kcptun luci-app-zerotier vlmcsd luci-app-vlmcsd"
for dir in $plist
do
    if [ -d $dir ]
    then
        echo "Copying plugin $dir to /workdir/openwrt/package/lean ..."
        cp -rp $dir /workdir/openwrt/package/lean/
    else
        echo "$dir does not exists..."
    fi
done

cd /workdir/openwrt
[ -d /workdir/openwrt/feeds/gli_pub/shadowsocks-libev ] && mv /workdir/openwrt/feeds/gli_pub/shadowsocks-libev /workdir/openwrt/feeds/gli_pub/shadowsocks-libev.bak
if [ -d /workdir/lede/feeds/packages/net/shadowsocks-libev ]
then
    [ -d /workdir/openwrt/feeds/packages/net/shadowsocks-libev ] && mv /workdir/openwrt/feeds/packages/net/shadowsocks-libev /workdir/openwrt/feeds/packages/net/shadowsocks-libev.bak
    [ -d /workdir/openwrt/feeds/gli_pub ] && cp -r /workdir/lede/feeds/packages/net/shadowsocks-libev /workdir/openwrt/feeds/gli_pub/shadowsocks-libev
    [ -d /workdir/openwrt/package/lean/helloworld ] && cp -r /workdir/lede/feeds/packages/net/shadowsocks-libev /workdir/openwrt/package/lean/helloworld/
    cp -r /workdir/lede/feeds/packages/net/shadowsocks-libev /workdir/openwrt/feeds/packages/net/shadowsocks-libev
fi

rm -rf /workdir/openwrt/feeds/packages/net/wget
cp -rp /workdir/lede/package/lean/wget /workdir/openwrt/feeds/packages/net/wget
cp -rp /workdir/lede/package/lean/wget /workdir/openwrt/package/lean/wget

# Clone community packages to package/community
mkdir package/community
cd /workdir/openwrt/package/community

# Add Lienol's Packages
#git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add gotop
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/gotop

# Add smartdns
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt ../smartdns
svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/luci-app-smartdns ../luci-app-smartdns

# Add adbyby
cp -r /workdir/lede/package/lean/adbyby ./
cp -r /workdir/lede/package/lean/luci-app-adbyby-plus ./
