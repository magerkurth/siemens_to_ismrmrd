#Script for downloading additional dependencies for gt_siemens_apps on windows

function download_file($url,$destination) {
    #Let's set up a webclient for all the files we have to download
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url,$destination)
}

function unzip($zipPath, $destination){
    $shell = new-object -com shell.application;
    $zip = $shell.NameSpace($zipPath);
    if ((Test-Path -path $destination) -ne $True)
    {
        New-Item $destination -type directory
    }
    foreach($item in $zip.items()){
        $shell.Namespace($destination).copyhere($item)
    }
}

$library_location = "C:\MRILibraries"
$download_location = "C:\MRILibraries\downloads"


download_file "ftp://ftp.zlatkovic.com/libxml/zlib-1.2.5.win32.zip" ($download_location + "\zlib-1.2.5.win32.zip")
download_file "ftp://ftp.zlatkovic.com/libxml/iconv-1.9.2.win32.zip" ($download_location + "\iconv-1.9.2.win32.zip")
download_file "ftp://ftp.zlatkovic.com/libxml/libxml2-2.7.8.win32.zip" ($download_location + "\libxml2-2.7.8.win32.zip")
download_file "ftp://ftp.zlatkovic.com/libxml/libxslt-1.1.26.win32.zip" ($download_location + "\libxslt-1.1.26.win32.zip")

if ((Test-Path -path ($library_location + "\xslt")) -ne $True) {
    New-Item ($library_location + "\xslt")  -type directory
}

unzip ($download_location + "\zlib-1.2.5.win32.zip") ($download_location + "\zlib")
unzip ($download_location + "\iconv-1.9.2.win32.zip") ($download_location + "\iconv")
unzip ($download_location + "\libxml2-2.7.8.win32.zip") ($download_location + "\xml2")
unzip ($download_location + "\libxslt-1.1.26.win32.zip") ($download_location + "\xslt")

copy ($download_location + "\iconv\iconv-1.9.2.win32\bin\iconv.dll") ($library_location + "\xslt")
copy ($download_location + "\zlib\zlib-1.2.5\bin\zlib1.dll") ($library_location + "\xslt")
copy ($download_location + "\xml2\libxml2*\bin\*.dll") ($library_location + "\xslt")
copy ($download_location + "\xslt\libxslt*\bin\*.dll") ($library_location + "\xslt")
copy ($download_location + "\xslt\libxslt*\bin\xsltproc.exe") ($library_location + "\xslt")

Write-Host "Now add $library_location\xslt to you PATH environment variable"