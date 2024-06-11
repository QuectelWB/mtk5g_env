#!/bin/bash

install_requirements()
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !....Installing requirement Packages.........  !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo
if [[ $HWE = "yes" ]] && [[ "$version" = *"Ubuntu 18.04"* ]];
then
sudo apt install  -y lib32stdc++6
sudo apt install  -y bison gcc make build-essential libc6-dev-i386 libncurses-dev wget coreutils
sudo apt install  -y  diffstat gawk git git-core help2man libtool libxml2-dev quilt
sudo apt install  -y  sed subversion texi2html texinfo unzip flex libtinfo5
sudo apt install  -y re2c  g++ python-pip  python2
sudo apt install  -y python
sudo pip install enum34
else
    sudo apt-get update -y
fi
}

get_binaries() { 
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Download    Binaries.........Proceeding.  ! \e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo

#cd ~/Downloads
Dwnload=$(xdg-user-dir DOWNLOAD)
cd $Dwnload
# wget https://github.com/ninja-build/ninja/archive/v1.8.2/ninja-1.8.2.tar.gz
# tar  xvf  ninja-1.8.2.tar.gz
git clone https://github.com/QuectelWB/mtk5g_env.git

cd  mtk5g_env
}

compile_source() { 

cd  $Dwnload/mtk5g_env/ninja-1.8.2
./bootstrap.py

chmod 777 ninja
sudo cp  ninja  /usr/bin

cd  $Dwnload/mtk5g_env/

sudo chmod +x gn_git/gn
sudo cp gn_git/gn  /usr/bin/
}

setup_python_env()
{
echo
/bin/echo -e "\e[1;36m   !---------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   !   Python 必须是Python2                                        !\e[0m"
/bin/echo -e "\e[1;36m   !---------------------------------------------------------------!\e[0m"
echo
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2   2
}

perl_modules()
{
sudo perl  $Dwnload/mtk5g_env/install_modules.pl
}

ScriptVer="1.0.0"
echo
/bin/echo -e "\e[1;36m   !---------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   !   Ubuntu 编译环境必须是	18.04                              !\e[0m"
/bin/echo -e "\e[1;36m   !---------------------------------------------------------------!\e[0m"
echo


if [[ $EUID -ne 0 ]]; then
	/bin/echo -e "\e[1;36m   !-------------non root-------------------------------------------!\e[0m"
else
	echo
	/bin/echo -e "\e[1;31m   !-----------Do not use root, exit--------------------------------!\e[0m"
	echo
	exit
fi

check_ubuntu_version()
{

version=$(lsb_release -sd)
codename=$(lsb_release -sc)

echo
/bin/echo -e "\e[1;33m   |-| Detecting Ubuntu version        \e[0m"
if  [[ "$version" = *"Ubuntu 18.04"* ]];
then
	/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
	echo
elif [[ "$version" = *"Ubuntu 20.04"* ]];
then
	/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
	echo
elif [[ "$version" = *"Ubuntu 20.10"* ]];
then
	/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
	echo
elif [[ "$version" = *"Ubuntu 21.04"* ]];
then
	/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
	echo
else
	/bin/echo -e "\e[1;31m  !--------------------------------------------------------------!\e[0m"
	/bin/echo -e "\e[1;31m  !--------------------------------------------------------------!\e[0m"
	echo
	exit
fi
}
 
#
check_make_version()
{
make_version=$(make --version | grep -oP '(?<=GNU Make )([0-9]+\.[0-9]+)')
major_version=$(echo "$make_version" | cut -d. -f1)
minor_version=$(echo "$make_version" | cut -d. -f2)

if [ "$major_version" -gt 4 ] || ([ "$major_version" -eq 4 ] && [ "$minor_version" -ge 1 ]); then
    echo "当前make版本为 $make_version，符合要求。"
    # whiptail --title "make check" --msgbox " 当前版本 大于4.1 , pass." 10 60
else
	echo 
	/bin/echo -e "\e[1;31m  !--------------------------------------------------------------!\e[0m"
    echo "警告：当前make版本为 $make_version，建议升级到4.1以上版本。"
	/bin/echo -e "\e[1;31m  !--------------------------------------------------------------!\e[0m"
	echo 
	whiptail --title "make check" --msgbox " 当前版本 小于4.1 无法使用." 10 60
	exit -1
fi

}




check_ubuntu_version

check_make_version

install_requirements

get_binaries

compile_source

perl_modules

setup_python_env


echo "-------------done---------------"
exit 0
