# helm-plugin-sops
Helm plugin to decrypt value files encrypted using SOPS

## References

* https://helm.sh/docs/topics/plugins/
* https://github.com/mozilla/sops
* https://helm.sh/docs/helm/helm_install/
* https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
* https://kubectl.docs.kubernetes.io/guides/extending_kustomize/

## Development

```bash
eval $(helm env |grep '^HELM_PLUGINS=')
mkdir -p "${HELM_PLUGINS}"
cd "${HELM_PLUGINS}"
git clone git@github.com:dean-taylor/helm-plugin-sops.git sops
```
