ckear
scm
git clone https://github.com/cswl/scripts.git
ls
cd scripts
ls
./scm
bash scm
ls
scm
git push
ls
cd android
ls
bash curls
bash xvfb
bash xvdn status
bash xvfb start
ls
bash xvfb status
cd ..
ls
cd externel
cd external
ls
bash arch-bootstrap.sh
bash arch-bootstrap.sh -a arm
bash java-setup-debian
proot -0 bash java-setup-debian
pkg install proot
proot -0 bash java-setup-debian
ls
python ps.mem.py
python2 ps_mem.py
bash smem
ls
cd ..
ls
cd common
ls
bash lindent
bash pathlist
bash chroma
bash wget-mirror
ls
bash VBoxClient-run
bash shhd-hostkeygen.sh
ls
cd ..
ls
cd git
ls
bash git-all-subdirs.sh
bash git-author-rewrite.sh
ls
tree
ls
bash git-update-all.sh
ls
bash git-update.sh
ls
cd ..
ls
cd github
ls
bash ghraw
bash github-shallow-clone
ls
cd ..
ls
cd linux
ls
bash buddyinfo
ls
python iomemparser.py
~/.bash_profile
pkg install python2 
apt install texlive
apt-get install xterm synaptic pulseaudio
ls
python iomemparser.py
python2 iomemparser.py
ls
cd ..
ls
tree
cd external
ls
python2 ps_mem.py
proot -0 python2 ps_mem.py
bash ketchup-0.9
ls
bash smem
ls
bash ubuntu-mirror-list
ls
cd ..
ls
cd
ls
apt update
apt install vifm
ls
apt search t
apt install sshpass
ls
apt install datamash
apt install emacs
ls
# Build with:
# docker build -t termux/package-builder .
# Push to docker hub with:
# docker push termux/package-builder
# This is done after changing this file or any of the
# scripts/setup-{ubuntu,android-sdk}.sh setup scripts.
FROM ubuntu:17.10
# Fix locale to avoid warnings:
ENV LANG C.UTF-8
# Needed for setup:
COPY ./setup-ubuntu.sh /tmp/setup-ubuntu.sh
COPY ./setup-android-sdk.sh /tmp/setup-android-sdk.sh
# Setup needed packages and the Android SDK and NDK:
RUN apt-get update &&     apt-get -yq upgrade &&     apt-get install -yq sudo &&     adduser --disabled-password --shell /bin/bash --gecos "" builder &&     echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder &&     chmod 0440 /etc/sudoers.d/builder &&     su - builder -c /tmp/setup-ubuntu.sh &&     su - builder -c /tmp/setup-android-sdk.sh &&     apt-get clean &&     rm -rf /var/lib/apt/lists/* &&     cd /home/builder/lib/android-ndk/ &&     rm -Rf toolchains/mips* &&     rm -Rf sources/cxx-stl/gabi++ sources/cxx-stl/system sources/cxx-stl/stlport sources/cxx-stl/gnu-libstdc++ &&     cd /home/builder/lib/android-sdk/tools && rm -Rf emulator* lib* proguard templates
# We expect this to be mounted with '-v $PWD:/home/builder/termux-packages':
WORKDIR /home/builder/termux-packages
-v $PWD:/home/builder/termux-packages
ls
docker-info
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/artful64"
  # use vagrant-disksize plugin to resize partition - https://github.com/sprotheroe/vagrant-disksize
  config.disksize.size = '50GB'
  
  config.vm.provider "virtualbox" do |vb|     vb.memory = "2048"
  end
  # Share the root of the repo
  config.vm.synced_folder "../", "/termux-packages"
  # Disable the default /vagrant share directory, as it shares the directory with the Vagrantfile in it, not the repo root
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # filesystem needs to be resized
  config.vm.provision "shell", inline: "sudo resize2fs /dev/sda1"
  
  # helpful before setup-ubuntu.sh is run
  config.vm.provision "shell", inline: "sudo apt-get update"
  # Run provisioning scripts
  config.vm.provision "shell", path: "./setup-ubuntu.sh", privileged: false
  config.vm.provision "shell", path: "./setup-android-sdk.sh", privileged: false
  # Fix permissions on the /data directory in order to allow the "vagrant" user to write to it
  config.vm.provision "shell",
    inline: "sudo chown -R vagrant /data"
  # Tell the user how to use the VM
  config.vm.post_up_message = "Box has been provisioned! Use 'vagrant ssh' to enter the box. The repository root is available under '/termux-packages'."
end
ls
#!/bin/sh
echo "This script sets up the Termux App."
masterzip_url="https://github.com/alexs77/termux-config/archive/master.zip"
masterzip_file="$HOME/tmp/termux-config-master.zip"
masterzip_dir="$HOME/tmp/termux-config"
master_dir="$masterzip_dir/termux-config-master"
package_file="$master_dir/data/packages.txt"
mkdir -p "$HOME/tmp" "$HOME/bin"
[ -f "$masterzip_file" ] || wget -O "$masterzip_file" "$masterzip_url"
rm -rf "$masterzip_dir"
mkdir -p "$masterzip_dir"
busybox unzip -d "$masterzip_dir" "$masterzip_file"
packages="`busybox sed 's, -.*,,' "$package_file"`"
apt install -y $packages
cp -rp "$master_dir/data/HOME/." "$HOME"
rm -f "$HOME/.vimrc"
ln -s ".vim/.vimrc" "$HOME/.vimrc"
exit $?
