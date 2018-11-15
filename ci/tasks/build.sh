#!/bin/bash
cd app-repo

echo I am in `pwd`
ls -l ../

echo "starting build ..."

dotnet restore -r ubuntu.14.04-x64
dotnet publish -f netcoreapp1.0 -r ubuntu.14.04-x64 -o ./publish

echo "copying files to ../build-output"
cp manifest.yml ../build-output

wget -c https://github.com/miclip/dotnet-extensions/releases/download/v0.7/dotnet-ext-linux.tar.gz -O dotnet-ext-linux.tar.gz 
tar -xvzf dotnet-ext-linux.tar.gz

echo list dir
ls
chmod +x /bin/dotnet-ext-pack 
chmod +x /bin/dotnet-ext-nuget
ln -s /bin/dotnet-ext-pack /usr/local/bin/
ln -s /bin/dotnet-ext-nuget /usr/local/bin/

dotnet pack-ext --version

dotnet pack-ext ./NugetResource.TestApplication.csproj -p:PackageVersion=$(dotnet nuget-ext versions 
--name NugetResource.TestApplication --latest 
--source https://www.myget.org/F/dotnet-resource-test/api/v3/index.json 
--increment --version-spec "1.0.*") --basepath ./publish --no-publish --no-build

cp *.nupkg ../build-output