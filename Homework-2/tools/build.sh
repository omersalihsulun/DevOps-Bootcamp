#!/bin/bash

#######################################################
# Author: Ömer Salih Sülün <omersalih.sulun@gmail.com>#
# Date: 05.06.2022                                    #
# Github: @omersalihsulun                             #
# ./build.sh or bash build.sh to run the script       #
# ./build.sh -h for help                              #
#######################################################

BUILD_COMMAND="mvn package"
USAGE="
Usage:
    -b  <branch_name>     Branch name
    -n  <new_branch>      Create new branch
    -f  <zip|tar>         Compress format
    -p  <artifact_path>   Copy artifact to spesific path
    -d  <debug_mode>      Enable debug mode (default: false) <true|false>
    -h  <help>            Show this help"
#Debug modunun default olarak kapalı olduğu usage kısmında belirtildi.
usage(){
    echo "${USAGE}"
    exit 1
}
#Yapılacak işlemin dışarıdan parametre olarak gönderilip, kullanılmasını sağlayacak yapı.
while getopts ":b:n:f:p:d:h:" flag
do
    case "${flag}" in
        b)
            BRANCH_NAME=${OPTARG}
            if [ -z "${BRANCH_NAME}" ]; then
                echo "Branch name is empty"
                usage
            fi
            if [ ["${BRANCH_NAME}" == "master"] || ["${BRANCH_NAME}" == "main"] ]; then
                echo "You are currently on ${BRANCH_NAME} branch. Please be careful."
            fi
            git checkout $BRANCH_NAME
            #Master veya main branch'te olup olmadığı kontrol edildi. Aynı zamanda veri girişi kontrolü yapıldı. Main ve master ile ilgili uyarı basıldıktan sonra git checkout yapıldı.
            ;;
        n)
            NEW_BRANCH=${OPTARG}
            git branch $NEW_BRANCH
            git checkout $NEW_BRANCH
            #Yeni bir branch oluşturduk ve oluşturduktan sonra o Branch'a git checkout yaptık.
            ;;
        f)
            COMPRESS_FORMAT=${OPTARG}
            #ZIP veya TAR formatı seçildi. Bunların dışında bir giriş kabul edilmedi.
            if [ "${COMPRESS_FORMAT}" != "zip" ] || [ "${COMPRESS_FORMAT}" != "tar" ]; then
                echo "Compress format must be zip or tar"
                exit 1
            fi
            if [ "${COMPRESS_FORMAT}" == "zip" ]; then
                zip -r ${BRANCH_NAME}.zip ${ARTIFACT_PATH}
            else
                tar -zcvf ${BRANCH_NAME}.tar.gz ${ARTIFACT_PATH}
            fi
            #Zip için farklı, tar için farklı komutlar çalışacağı için seçime göre komutlar çalışıtırlıp kullanıcıdan alınan dizinin altına yedeklemeler gerçekleştirildi.
            #Yedek ismi için Branch ismi kullanıldı.

            ;;
        p)
            ARTIFACT_PATH=${OPTARG}
            if [ -z "${ARTIFACT_PATH}" ]; then
                echo "Artifact path is empty, default path will be used (/target)"
                ARTIFACT_PATH="/target"
                usage
            fi
            #Artıfact path için değer girilmediyse /target dizini altına yedekleme gerçekleştirildi.
            ;;
        d)
            DEBUG_MODE=${OPTARG}
            #DEBUG modda çalışıtırlması istenirse debug mode'a değer atanıyor.
            ;;
        h)
            usage
            ;;
        *)
            usage
            #Default durumda kullanım bilgisi çalıştırılıyor.
            ;;
    esac
done
#Debug mode'da çalışacaksa komuta -X parametresi ekleniyor.
if [ "${DEBUG_MODE}" == "true" ]; then
    echo "Debug mode is enabled"
    echo "Branch name: ${BRANCH_NAME}"
    echo "New branch: ${NEW_BRANCH}"
    echo "Compress format: ${COMPRESS_FORMAT}"
    echo "Artifact path: ${ARTIFACT_PATH}"
    BUILD_COMMAND+=" -X"
fi

eval "$BUILD_COMMAND"
#Son olarak build komutu çalıştırıldı.
