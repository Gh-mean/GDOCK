echo '修改机器名称'
sed -i 's/OpenWrt/GHOST/g' package/base-files/files/bin/config_generate

#echo '修改网关地址'
#sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

echo '修改时区'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

echo '修改默认主题'
sed -i 's/config internal themes/config internal themes\n    option Argon  \"\/luci-static\/argon\"/g' feeds/luci/modules/luci-base/root/etc/config/luci

echo '删除旧版argon,链接新版'
rm -rf ./package/lean/luci-theme-argon
ln -s ../../../luci-theme-argon ./package/lean/

echo '修改banner'
rm -rf package/base-files/files/etc/banner
cp -f ../banner package/base-files/files/etc/

echo '下载ServerChan'
git clone https://github.com/tty228/luci-app-serverchan ../diy/luci-app-serverchan

echo '下载helloword'
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

echo '集成diy目录'
ln -s ../../diy ./package/openwrt-packages

echo '下载openclash'
mkdir package/luci-app-openclash
cd package/luci-app-openclash
git init
git remote add -f origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull origin master
git branch --set-upstream-to=origin/master master
pushd package/luci-app-openclash/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
