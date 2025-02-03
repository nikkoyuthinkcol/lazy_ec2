# Quick Start
Make sure you are using **bash, not sh**.

Recommend Bash >=5.2. Older bash are not tested.

To install all packages (default: CPU)
```
make all
```

To install all packages for **GPU**
```
make gpu
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

## When I SSH to the EC2, it doesn't let me in even I am sure the keys are correct.

Try removing the fingerprint from the `known_hosts` file, and try connecting again. For windows, it is located at `C:\Users\<username>\.ssh`
