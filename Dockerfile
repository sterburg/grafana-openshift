FROM centos:7

WORKDIR /usr/share/grafana

RUN yum -y install unzip https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.x86_64.rpm && \
    curl -L -o plugin.zip https://github.com/hawkular/hawkular-grafana-datasource/archive/master.zip && unzip plugin.zip && \
    mkdir -p /usr/share/grafana/public/app/plugins/datasource/hawkular && \
    mv hawkular-grafana-datasource-master/dist/* /usr/share/grafana/public/app/plugins/datasource/hawkular/ && \
    yum -y remove unzip && yum clean all && rm -rf plugin.zip hawkular-grafana-datasource-master /tmp/* /var/tmp/*

ADD grafana.ini /etc/grafana
ADD run.sh /usr/share/grafana
RUN for d in /usr/share/grafana /etc/grafana /var/lib/grafana /var/log/grafana; do chgrp -R 0 $d; chmod -R g+rwX $d; done

EXPOSE 3000
CMD ["./run.sh"]
