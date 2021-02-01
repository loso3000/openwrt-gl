cd openwrt/bin/targets/*/*
mkdir ssrp

# plugin list in ../../../packages/mipsel_24kc
pkglist="luci/luci_*.ipk luci/luci-i18n-base-zh-cn_*.ipk packages/ttyd_*.ipk luci/luci-app-ttyd_*.ipk packages/wget_*.ipk luci/luci-i18n-ttyd-zh-cn_*.ipk packages/htop_*.ipk base/shadowsocksr-libev-alt_*.ipk base/pdnsd-alt_*.ipk base/microsocks_*.ipk base/dns2socks_*.ipk base/shadowsocksr-libev-ssr-local_*.ipk base/simple-obfs_*.ipk base/tcping_*.ipk base/v2ray-plugin_*.ipk base/xray_*.ipk base/trojan_*.ipk base/ipt2socks_*.ipk base/redsocks2_*.ipk base/luci-app-ssr-plus_*.ipk base/luci-i18n-ssr-plus-zh-cn_*.ipk luci/luci-compat_*.ipk luci/luci-lib-ipkg_*.ipk"

for pkg in $pkglist
do
    file=../../../packages/mipsel_24kc/$pkg
    ls=`ls $file 2>/dev/null`
    if [ -z $ls ]
    then
        echo "$pkg does not exists."
    else
        echo "Copying $pkg to ssrp..."
        cp $file ./ssrp/
    fi
done

cat << EOF > ./ssrp/install-ssrp.sh
opkg update
opkg install luci luci-i18n-base-zh-cn ttyd luci-app-ttyd wget
opkg install ./luci-i18n-ttyd-zh-cn_*.ipk
opkg install ./htop_*.ipk
opkg install ./shadowsocksr-libev-alt_*.ipk
opkg install ./pdnsd-alt_*.ipk 
opkg install ./microsocks_*.ipk 
opkg install ./dns2socks_*.ipk 
opkg install ./shadowsocksr-libev-ssr-local_*.ipk 
opkg install ./simple-obfs_*.ipk
opkg install ./tcping_*.ipk 
opkg install ./v2ray-plugin_*.ipk 
opkg install ./xray_*.ipk 
opkg install ./trojan_*.ipk 
opkg install ./ipt2socks_*.ipk
opkg install ./redsocks2_*.ipk 
opkg install ./luci-app-ssr-plus_*.ipk
opkg install ./luci-i18n-ssr-plus-zh-cn_*.ipk
opkg install ./luci-compat_*.ipk --force-overwrite
opkg install ./luci-lib-ipkg_*.ipk
EOF

chmod +x ./ssrp/install-ssrp.sh

tar czvf ssrp.tar.gz ./ssrp
rm -rf ./ssrp
