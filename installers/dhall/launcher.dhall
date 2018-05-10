\(cluster : ./cluster.type) ->
\(os      : ./os.type)      ->
{ configuration  =
    { filePath     = os.configurationYaml
    , key          = "${cluster.keyPrefix}_${os.name}"
    , systemStart  = [] : Optional Integer
    , seed         = [] : Optional Integer
    }
, nodeTimeoutSec = 60
, reportServer   = cluster.reportServer
, walletArgs     = [] : List Text
, tlsPath        = os.nodeArgs.tlsPath
, x509ToolPath   = os.x509ToolPath
, nodeArgs =
    [ "--tlsca",               "${os.nodeArgs.tlsPath}/ca.crt"
    , "--tlscert",             "${os.nodeArgs.tlsPath}/server.crt"
    , "--tlskey",              "${os.nodeArgs.tlsPath}/server.key"
    , "--update-server",       cluster.updateServer
    , "--keyfile",             os.nodeArgs.keyfile
    , "--logs-prefix",         os.nodeArgs.logsPrefix
    , "--topology",            os.nodeArgs.topology
    , "--wallet-db-path",      os.nodeArgs.walletDBPath
    , "--update-latest-path",  os.nodeArgs.updateLatestPath
    , "--wallet-address",      "127.0.0.1:8090"
    -- XXX: this is a workaround for Linux
    , "--update-with-package"
    ]
} // os.pass
