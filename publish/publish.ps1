# Copyright Dirk Lemstra https://github.com/dlemstra/Magick.NET.
# Licensed under the Apache License, Version 2.0.

param (
    [string]$quantumName = $env:QuantumName,
    [string]$platformName = $env:PlatformName,
    [string]$version = $env:NuGetVersion,
    [string]$commit = $env:GitCommitId,
    [parameter(mandatory=$true)][string]$destination
)

. $PSScriptRoot\..\tools\windows\utils.ps1
. $PSScriptRoot\publish.shared.ps1

function addMagickNetLibraries($xml, $quantumName, $platform) {
    addLibrary $xml "Magick.NET" $quantumName $platform "net8.0"
}

function addOpenMPLibrary($xml, $platform) {
    $redistFolder = "$($env:VSINSTALLDIR)VC\Redist\MSVC"
    $redistVersion = (ls -Directory $redistFolder -Filter 14.* | sort -Descending | select -First 1 -Property Name).Name
    $source = "$redistFolder\$redistVersion\$platform\Microsoft.VC143.OpenMP\vcomp140.dll"
    $target = "runtimes\win-$platform\native\vcomp140.dll"
    addFile $xml $source $target
}

function addNotice($xml) {
    $source = fullPath "src\Magick.Native\libraries\Notice.txt"
    $target = "Notice.txt"
    addFile $xml $source $target
}

function addNativeLibrary($xml, $platform, $runtime, $suffix) {
    $source = fullPath "src\Magick.Native\libraries\$runtime\libMagick.Native-$suffix"
    $target = "runtimes\$runtime-$platform\native\libMagick.Native-$suffix"
    addFile $xml $source $target
}

function addNativeLibraries($xml, $quantumName, $platform) {
    if ($platform -eq "AnyCPU") {
        addNativeLibraries $xml $quantumName "x86"
        addNativeLibraries $xml $quantumName "x64"
        addNativeLibraries $xml $quantumName "arm64"
        return
    }

    addNativeLibrary $xml $platform "win" "$quantumName-$platform.dll"

    if ($platform -eq "x86") {
        return
    }

    if ($quantumName.EndsWith("-OpenMP")) {
        addOpenMPLibrary $xml $platform
    } else {
        addNativeLibrary $xml $platform "osx" "$quantumName-$platform.dll.dylib"
    }

    addNativeLibrary $xml $platform "linux" "$quantumName-$platform.dll.so"

    if ($platform -eq "x64") {
        addNativeLibrary $xml $platform "linux-musl" "$quantumName-$platform.dll.so"
    }
}

function createMagickNetNuGetPackage($quantumName, $platform, $version, $commit) {
    $xml = loadAndInitNuSpec "Magick.NET" $version $commit

    $name = "Magick.NET-$quantumName-$platform"
    $xml.package.metadata.id = $name
    $xml.package.metadata.title = $name

    addMagickNetLibraries $xml $quantumName $platform
    addNativeLibraries $xml $quantumName $platform
    addNotice $xml

    createNuGetPackage $xml $name $version
}

$platform = $platformName

if ($platform -eq "Any CPU") {
    $platform = "AnyCPU"
}

createMagickNetNuGetPackage $quantumName $platform $version $commit
copyNuGetPackages $destination
