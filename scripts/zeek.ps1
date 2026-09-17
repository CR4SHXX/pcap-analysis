$ZeekImage = "zeek/zeek:9.0.0"            # pinned Zeek version
$ZeekRepo  = "C:\pcap-analysis"           # repo root mounted into the container

# zeek-run: analyze pcaps\<file> and write logs to zeek-logs\<name>\
function zeek-run {
    param([Parameter(Mandatory)] [string]$Pcap)
    $Pcap = $Pcap -replace '\\', '/'    # convert Windows \ to Linux / for the container
    $name = [IO.Path]::GetFileNameWithoutExtension($Pcap)       # file name without extension
    New-Item -ItemType Directory -Force "$ZeekRepo\zeek-logs\$name" | Out-Null   # create output folder
    docker run --rm -v "${ZeekRepo}:/data" -w "/data/zeek-logs/$name" $ZeekImage `
        zeek -C -r "/data/pcaps/$Pcap" local                    # run Zeek, ignore checksums, load default scripts
}

# zeek: raw passthrough, works on files in the current folder
function zeek {
    docker run --rm -v "${PWD}:/data" -w /data $ZeekImage zeek @args
}

# zeek-cut: pipe a log in, pick columns (e.g. Get-Content conn.log | zeek-cut id.orig_h id.resp_h)
function zeek-cut {
    $input | docker run -i --rm $ZeekImage zeek-cut @args
}
