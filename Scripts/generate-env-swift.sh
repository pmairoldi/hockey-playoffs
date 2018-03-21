#!/bin/sh
if ! [ -e $1 ]
then

if [ -z $2 ]
then
cat > $1 << EOF
struct Env {
    static let host = <#T##API Host#>
}
EOF
else 
cat > $1 << EOF
struct Env {
    static let host = "$2"
}
EOF
fi

if [ -z $2 ]
then
    echo "warning: Created Env.swift file. Update it to include API Host and build again."
fi

fi