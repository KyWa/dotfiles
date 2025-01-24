# DevSpaces

## GitHub CoPilot
With GitHub CoPilot being a unique Microsoft owned extension, you cannot install it in DevSpaces when using the `open-vsx.org` plugin registry and need to download it manually and install with `code --install-extension /path/to/file.vsix`. To download the `vsix` files for GitHub CoPilot and CoPilot Chat, you currently have to essentially copy a link and replace a value with the needed version. Links below:

* [Copilot](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/1.221.1043/vspackage)
* [Copilot Chat](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/0.19.2024080501/vspackage)

```sh
curl -o - https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/0.19.2024080501/vspackage | gunzip > chat.vsix
curl -o - https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/1.221.1043/vspackage | gunzip > ghp.vsix

code-oss --install-extension chat.vsix
code-oss --install-extension ghp.vsix
```

Logging out and back in does get it to a point where you can then sign in with GitHub Copilot Chat which then allows the login and you can then "Grant access to account from GitHub Copilot Chat", which does nothing and still results in the following even adding a GitHub Oauth secret into the `CheCluster` (which made no difference):

```
2025-01-24 18:28:23.725 [info] [CopilotTokenManager] Logged in as KyWa
2025-01-24 18:28:23.783 [info] [CopilotTokenManager] Invalid copilot token: missing token: 404 

kind: Secret
apiVersion: v1
metadata:
  name: github-oauth-config
  namespace: openshift-operators
  labels:
    app.kubernetes.io/component: oauth-scm-configuration
    app.kubernetes.io/part-of: che.eclipse.org
  annotations:
    che.eclipse.org/oauth-scm-server: github
    che.eclipse.org/scm-server-endpoint: 'https://github.com'
data:
  id: CLIENT_ID
  secret: CLIENT_SECRET
type: Opaque


oc patch checluster devspaces --type=merge -p '{"spec":{"gitServices":{"github":[{"endpoint":"https://github.com","secretName":"github-oauth-config"}]}}}' -n openshift-operators
```
