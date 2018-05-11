\(cluster : ./cluster.type)      ->
let dataDir = "\${XDG_DATA_HOME}/Daedalus"
in
{ name      = "linux64"
, configurationYaml  = "\${DAEDALUS_CONFIG}/configuration.yaml"
, x509ToolPath       = "cardano-x509-certificates"
, nodeArgs           =
  { keyfile          = "${dataDir}/${cluster.name}/Secrets/secret.key"
  , logsPrefix       = "${dataDir}/${cluster.name}/Logs"
  , topology         = "\${DAEDALUS_CONFIG}/wallet-topology.yaml"
  , updateLatestPath = "${dataDir}/${cluster.name}/installer.sh"
  , walletDBPath     = "${dataDir}/${cluster.name}/Wallet/"
  , tlsPath          = "${dataDir}/${cluster.name}/tls"
  }
, pass      =
  { nodePath            = "cardano-node"
  , nodeDbPath          = "${dataDir}/${cluster.name}/DB/"
  , nodeLogConfig       = "\${DAEDALUS_CONFIG}/daedalus.yaml"
  , nodeLogPath         = "${dataDir}/${cluster.name}/Logs/cardano-node.log"

  , walletPath          = "daedalus-frontend"
  , walletLogging       = False
  , frontendOnlyMode    = True

  -- todo, find some way to disable updates when unsandboxed?
  , updaterPath         = "/bin/update-runner"
  , updaterArgs         = [] : List Text
  , updateArchive       = [ "${dataDir}/${cluster.name}/installer.sh" ] : Optional Text
  , updateWindowsRunner = [] : Optional Text

  , launcherLogsPrefix  = "${dataDir}/${cluster.name}/Logs/"
  }
}
