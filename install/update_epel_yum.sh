#!/bin/bash
#
. ../base.sh

install_dir="/data0/install"
downloads_dir=$install_dir/downloads

file_name=epel-release-6-8.noarch.rpm
import_file=/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6


exe_cmd "cd $downloads_dir"

function download_files()
{ 
    # enter /data0/install/downloads

    exe_cmd "cd $downloads_dir"

    local_path=$downloads_dir/$file_name

    echo "download $file_name => $local_path"
    if [ -s $local_path ]; then
        echo "$file_name [found]"
    else
        echo "$file_name [not found]"
        exe_cmd "wget http://mirrors.hust.edu.cn/epel//6/x86_64/$file_name"
        if [ ! -f $local_path ]; then
            echo "Failed to download $1, please download it to "$downloads_dir" directory manually and rerun the install script."
            exit 1
        fi
    fi
}

function install_epel()
{
    if [ `id -u` -ne 0 ]; then
        echo "Superuser privileges are required to run this script."
        echo "e.g. \"sudo sh $0\""
        exit 1
    fi

    download_files

    exe_cmd "cd $downloads_dir"

    exe_cmd "rpm -ivh $file_name"

    exe_cmd "rpm --import $import_file"

    exe_cmd "yum clean all"
}

install_epel
