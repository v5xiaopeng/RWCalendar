#!/bin/bash

VersionString=`grep -E 's.version.*=' RWCalendar.podspec`
VersionNumber=`tr -cd 0-9 <<<"$VersionString"`

NewVersionNumber=$(($VersionNumber + 1))
LineNumber=`grep -nE 's.version.*=' RWCalendar.podspec | cut -d : -f1`
sed -i "" "${LineNumber}s/${VersionNumber}/${NewVersionNumber}/g" RWCalendar.podspec

echo "current version is ${VersionNumber}, new version is ${NewVersionNumber}"

git add .
git commit -am '页面布局采用Masonry'${NewVersionNumber}
git tag ${NewVersionNumber}
git push origin master --tags
pod repo push WZPRepoSpecs RWCalendar.podspec --verbose --allow-warnings --use-libraries

