FROM centos:6

MAINTAINER P Pavlov "ppavlov@nomail.com"

# yum update
RUN yum update -y

RUN echo "127.0.0.1    foreman.sainsburys.co.uk foreman" >> /etc/hosts

# install the katello-repos
RUN yum -y localinstall http://fedorapeople.org/groups/katello/releases/yum/3.1/katello/el6/x86_64/katello-repos-latest.rpm
RUN yum -y localinstall http://yum.theforeman.org/releases/1.12/el6/x86_64/foreman-release.rpm
RUN yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum -y localinstall http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN yum -y install foreman-release-scl

# install katello
RUN yum -y install katello

#Adding the Configuration files
ADD run.sh /run.sh
ADD foreman-answers.yaml /etc/foreman-installer/scenarios.d/foreman-answers.yaml 
ADD katello-answers.yaml /etc/foreman-installer/scenarios.d/katello-answers.yaml
ADD capsule-answers.yaml /etc/foreman-installer/scenarios.d/capsule-answers.yaml

### ports
# puppet (via apache)
EXPOSE 8140
# foreman-proxy
EXPOSE 8443
# foreman (via apache)
EXPOSE 443
EXPOSE 80
EXPOSE 8080

CMD ["/run.sh"]
