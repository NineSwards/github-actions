#!/bin/bash

KUBERNETES_RELEASE_VERSION="$(curl -sSL https://dl.k8s.io/release/stable.txt)"

KUBERNETES_VERSION=${INPUT_KUBERNETES_VERSION:=${KUBERNETES_RELEASE_VERSION}}
echo "currect version ${KUBERNETES_VERSION}"

curl -O -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubeadm
chmod +x kubeadm
images=$(./kubeadm config images list --kubernetes-version=${KUBERNETES_VERSION})

echo "image list: ${images}"

echo "${INPUT_PASSWORD}" | docker login -u ${INPUT_USERNAME} --password-stdin ${INPUT_REGISTRY}

while IFS='/' read key value; do
    image=${key}/${value}
    docker pull ${image}
    new_image=${INPUT_REPOSITORY}/${value}
    if [ -n "${INPUT_REGISTRY}" ]; then
        new_image=${INPUT_REGISTRY}/${new_image}
    fi
    docker tag ${image} ${new_image}
    docker push ${new_image}
done <<< ${images}