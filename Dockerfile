FROM alpine:latest
LABEL maintainer="Fatih Boy <fatih@entterprisecoding.com>"

# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.19.3"


RUN addgroup -S kube && adduser -S kube -G kube \
    && apk add --no-cache --update ca-certificates \
    && apk add --no-cache curl bash openssl git vim su-exec \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && su-exec kube bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" \
    && echo "DISABLE_AUTO_UPDATE=true" >> /home/kube/.bashrc \
    && sed -i "s/OSH_THEME=\"font\"/OSH_THEME=\"duru\"/g" /home/kube/.bashrc \
    && echo "source <(kubectl completion bash)" >> /home/kube/.bashrc \
    && echo "alias k=kubectl" >> /home/kube/.bashrc \
    && echo "complete -F __start_kubectl k" >> /home/kube/.bashrc \
    && apk del su-exec

USER kube

WORKDIR /home/kube

CMD exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"