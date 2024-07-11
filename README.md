# Quick Start
Make sure you are using **bash, not sh**.

Recommend Bash >=5.2. Older bash are not tested.

To install all packages
```
make all
```

To install partial packages, refer to the Makefile. In Makefile, find:
```
<target>: prerequisites
    command
    command
    command
```
and 
```
make <target>
```

# Tips and Tricks

Disable any interaction if you don't want to choose.
```
export DEBIAN_FRONTEND="noninteractive"
```

Find packages
```
apt-cache search <package>
```

# Common EC2 Problems:

## Help, I cannot lanuch an instance!

This maybe due to quota problem, try increasing **Running On-Demand [instance_type] instances**.