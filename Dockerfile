FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

ARG HELM_VERSION=v3.19.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && curl -fsSL \
        "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
        -o /tmp/helm.tar.gz \
    && tar -xzf /tmp/helm.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /tmp/helm.tar.gz /tmp/linux-amd64 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    ansible \
    kubernetes

COPY requirements.yml /tmp/requirements.yml

RUN ansible-galaxy collection install \
    -r /tmp/requirements.yml

WORKDIR /workspace

ENTRYPOINT ["ansible-playbook"]