is_in(){
    local i_item="${1}"
    shift
    local i_arr="$@"
    echo "${i_arr[@]}" | grep -wq "${i_item}" && return 0 || return 1
}

# test
status_zk(){
    echo "test ok"
    return 0
}

get_hosts() {
    o_ifs="${IFS}"
    IFS=','
    hosts=(${Nodes})
    IFS="${o_ifs}"
}

verify_module() {
    v_status=0
    for v_module in "$@"; do
        is_in "${v_module}" "${Modules[@]}" && continue
        echo "unrecognized module: ${v_module}!"
        v_status=1
    done
    return "${v_status}"
}
# 查看进程的状态
check() {
    check=$(ssh ${user}@${1} "sudo netstat -nltp | grep :${2} | wc -l")
    [ ${check} -gt 0 ] && echo "\033[32m服务正在运行!\033[0m（${1}）" || echo "\033[31m服务未启动!\033[0m（${1}）"
}
# 强杀Jps进程
shut_down() {
    ssh ${user}@${1} "jps | grep ${2} | awk '{print \$1}' | xargs kill -9"
}

start_nginx() {
    echo "Starting Nginx ......"
    ssh ${User}@${NginxNode} "sudo ${NginxHome}/sbin/nginx"
}
stop_nginx() {
    echo "Stopping Nginx ......"
    ssh ${User}@${NginxNode} "sudo ${NginxHome}/sbin/nginx -s stop"
}
start_zk() {
    mrun "echo ${ZookeeperHome}/bin/zkServer.sh start"
}
# 启动ES服务
start_es() {
    echo "Starting Elasticsearch ......"
    mrun "${EsHome}/bin/elasticsearch >/dev/null 2>&1 &"
    echo "Starting Kibana ......"
    ssh ${User}@${KibanaNode} "nohup ${KibanaHome}/bin/kibana >${KibanaHome}/logs/kibana.log 2>&1 &"
}
# 停止ES服务
stop_es() {
    echo "Stopping Kibana ......"
    ssh ${User}@${KibanaNode} "ps -aux | grep kibana | grep -v grep | awk '{print \$2}' | xargs kill -9"
    echo "Stopping Elasticsearch ......"
    getHosts all
    for host in ${hosts}; do
        shut_down ${host} Elasticsearch
    done
}
# 启动DolphinScheduler
start_dolphin() {
    ssh ${User}@${DolphinMaster} "${DolphinHome}/bin/start-all.sh"
}
# 停止DolphinScheduler
stop_dolphin() {
    ssh ${User}@${DolphinMaster} "${DolphinHome}/bin/stop-all.sh"
}
# 启动Maxwell
start_maxwell() {
    ssh ${User}@${MaxwellNode} "${MaxwellHome}/bin/maxwell --config ${MaxwellHome}/config.properties --daemon"
}
# 停止Maxwell
stop_maxwell() {
    echo "Stopping Maxwell ......"
    shut_down ${MaxwellNode} Maxwell
}
# 启动瘦子
start_thin() {
    echo "Starting Query Server ......"
    ssh ${User}@${PhoenixNode} "${PhoenixHome}/bin/queryserver.py start"
}
# 停止瘦子
stop_thin() {
    ssh ${User}@${PhoenixNode} "${PhoenixHome}/bin/queryserver.py stop"
}
# 启动HDFS
start_hdfs() {
    ssh ${User}@${NameNode} "${HadoopHome}/sbin/start-dfs.sh"
}
# 停止HDFS
stop_hdfs() {
    ssh ${User}@${NameNode} "${HadoopHome}/sbin/stop-dfs.sh"
}
# 启动YARN
start_yarn() {
    ssh ${User}@${ResourceManager} "${HadoopHome}/sbin/start-yarn.sh"
    #  ssh ${User}@${HistoryServer} "${HadoopHome}/bin/mapred --daemon start historyserver"
}
# 停止YARN
stop_yarn() {
    #  ssh ${User}@${HistoryServer} "${HadoopHome}/bin/mapred --daemon stop historyserver"
    ssh ${User}@${ResourceManager} "${HadoopHome}/sbin/stop-yarn.sh"
}
# 启动Hbase
start_hbase() {
    ssh ${User}@${HbaseNode} "${HbaseHome}/bin/start-hbase.sh"
}
# 停止Hbase
stop_hbase() {
    ssh ${User}@${HbaseNode} "${HbaseHome}/bin/stop-hbase.sh"
}
# 启动Redis
start_redis() {
    echo "Starting Redis ......"
    ssh ${User}@${RedisNode} "${RedisHome}/bin/redis-server /etc/redis.conf"
}
# 停止Redis
stop_redis() {
    echo "Stopping Redis ......"
    ssh ${User}@${RedisNode} "${RedisHome}/bin/redis-cli -h ${RedisNode} -p 6379 shutdown"
}
# 启动hive
start_hive() {
    echo "Starting Hive ......"
    ssh ${User}@${HiveNode} "nohup ${HiveHome}/bin/hive --service metastore >${HiveLogDir}/metastore.log 2>&1 &"
    ssh ${User}@${HiveNode} "${HadoopHome}/bin/hdfs dfsadmin -safemode wait >/dev/null 2>&1"
    ssh ${User}@${HiveNode} "nohup ${HiveHome}/bin/hive --service hiveserver2 >${HiveLogDir}/hiveServer2.log 2>&1 &"
}
# 停止hive
stop_hive() {
    echo "Stopping Hive ......"
    shut_down ${HiveNode} RunJar
}
# 启动kafka
start_kafka() {
    echo "Starting Kafka ......"
    mrun "${KafkaHome}/bin/kafka-server-start.sh -daemon ${KafkaHome}/config/server.properties >${KafkaHome}/kafka.log 2>&1"
}
# 停止kafka
stop_kafka() {
    echo "Stopping Kafka ......"
    mrun "${KafkaHome}/bin/kafka-server-stop.sh ${KafkaHome}/config/server.properties"
}
