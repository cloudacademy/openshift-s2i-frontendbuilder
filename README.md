
# OpenShift S2I Frontend Builder Image

### Files and Directories  
| File                   | Description                                                                      |
|------------------------|----------------------------------------------------------------------------------|
| Dockerfile             | Defines the base builder image                                                   |
| s2i/bin/assemble       | Script that builds the application                                               |
| s2i/bin/usage          | Script that prints the usage of the builder                                      |
| s2i/bin/run            | Script that runs the application                                                 |
| s2i/bin/save-artifacts | Script for incremental builds that saves the built artifacts (not used for demo) |


#### Dockerfile
Builds a nginx:mainline based image - includes yarn to compile the frontend React based UI

#### S2I scripts

##### assemble
Performs the *yarn install* and *yarn build* commands to compile the frontend React based UI

##### run
Executes the following to startup the nginx process:
```
exec /bin/bash -c 'cd /nginx/html && /tmp/src/env.sh && /usr/sbin/nginx -g "daemon off;"'
```

##### save-artifacts (optional)
Not used for demo

##### usage (optional) 
Prints out instructions on how to use the image
