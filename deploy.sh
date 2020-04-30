#!/bin/bash
env=slave
host=nas.host
port=8089
moduleName=`mvn -Dexec.executable='echo' -Dexec.args='${project.name}' --non-recursive exec:exec -q`
version=`mvn -Dexec.executable='echo' -Dexec.args='${project.version}' --non-recursive exec:exec -q`
registry=nas.host:8081/repository/registory

function run() {
    echo "----------run-step-1----------"
    echo "停止并删除旧版的docker容器 ${moduleName}"
    docker stop ${moduleName}
    docker rm ${moduleName}
    logPath=/home/docker/zhangshao-app-${env}/${moduleName}
    echo "----------run-step-2----------"
    echo "拉取打包好的镜像 docker pull ${registry}/${moduleName}:${version}"
    docker pull ${registry}/${moduleName}:${version}
    imgId=`docker images|grep ${registry}/${moduleName} |awk 'NR==1{print $3}'`
    echo "----------run-step-3----------"
    echo "运行容器 run -p${port}:${port} -v${logPath}:/logs --name ${moduleName} -d ${imgId}"
    docker run -p${port}:${port} -v${logPath}:/logs --name ${moduleName} -d ${imgId}
}
function build() {
    echo "----------docker build-step-1----------"
    echo "bulid"${moduleName}
    mvn  docker:build
}
function push() {
    echo "----------docker push-step-1----------"
    echo "tag ${moduleName} ${registry}/${moduleName}:${version}"
    docker tag ${moduleName} ${registry}/${moduleName}:${version}
    echo "----------docker push-step-2----------"
    echo "push ${registry}/${moduleName}:${version}"
    docker push ${registry}/${moduleName}:${version}
}
function mvnpackage(){
    echo "----------maven package-step-1----------"
    echo "mvn clean package -P${env} -DskipTests -U"
#    mvn resources:resouces
    mvn clean package -P${env} -DskipTests -U
    if [ $? -ne 0 ];then
        echo "[ERROR] mvn package failed!"
        exit 1
    fi
}

function deploy(){
    echo "mvn clean deploy -P${env} -DskipTests -U"
    mvn clean deploy -P${env} -DskipTests -U
    if [ $? -ne 0 ];then
        echo "[ERROR] mvn package failed!"
        exit 1
    fi
}
function environment() {
# 暂时意义不大
    echo $OPTARG
    if [[ $OPTARG = 'test' ]];then
        host=192.168.0.107
        env=test
        port=8072
    elif [[ $OPTARG = 'slave' ]];then
        host=192.168.0.107
        env=dev
        port=8082
    elif [[ $OPTARG = 'master' ]];then
        host=47.97.7.180
        env=prod
    fi
    echo "env is "${env}
}

function gethelp() {
    echo "-h for help"
    echo "-a for "
    echo "-e for 指定环境 默认test"
    echo "-m for maven  打包 mvn clean package -P${env} -DskipTests -U"
    echo "-b for maven  docker 构建 docker:build "
    echo "-p for docker 推送到远程私服仓库 docker push ${registry}/${moduleName}:${version}"
    echo "-r for docker 停止旧版docker容器
                        删除旧版docker容器
                        拉取打包好的镜像 docker pull ${registry}/${moduleName}:${version}
                        并运行 docker run -p${port}:${port} -v${logPath}:/logs "

}
while getopts "ae:mdbphr" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
         a)
            mvnpackage && build  && push
            ;;
         e)
            environment
            ;;
         m)
            mvnpackage
            ;;
         c)
            copy
            ;;
         d)
            deploy
            ;;
         h)
            gethelp
            ;;
         b)
            build
            ;;
         r)
            run
            ;;
         p)
            push
            ;;
         ?) #当有不认识的选项的时候arg为?
        echo "unkonw argument"
        gethelp
    exit 1
    ;;
    esac
done