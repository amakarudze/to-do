FROM jenkins/ssh-agent:6.9.0 as ssh-agent

RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils ca-certificates curl git python3 python3-venv python3-pip python3-setuptools python3-wheel python3-dev wget \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install docker-py feedparser nosexcover prometheus_client pycobertura pylint pytest pytest-cov requests setuptools sphinx pyinstaller

RUN pip install -r requirements.txt

RUN echo "PATH=${PATH}" >> /etc/environment

RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}"
