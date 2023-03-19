# name of image
FROM node:15    

# workding directiry to /app in container (all app code in /app)
WORKDIR /app    

# '.' for current directly that is app directory
COPY package.json .   
# RUN npm install

# run npm install --only=production only if node env is production
RUN if [ "$NODE_ENV" = "development" ]; \
        then npm install; \
        else npm install --only=production; \
        fi

# copy code to current directory
COPY . ./  
# copy everthing which is bad thing (use docker ignore to avoid copying unncessary files like node_modules)

# Why we copied package.json separetly?
# ANS: - Optimization technique
#     - docker treats each line of code as layers and caches them
#     - In development package.json dont chnage frequently
#     - when there is chnage in particular step it will rerun next steps as well regardless of caching
#     - so to avoid npm i to run everytime there is chnage in code and not in package.json we separated that part
#     - Next time you run docker build it will be faster

# expose port 3000 and entrypoint to start the code
ENV PORT 3000
#expose only expose internal it does not map with host port
EXPOSE $PORT 

# dev for nodemon
# CMD ["npm", "run", "dev"] 
CMD ["node", "index.js"]  


# 1. Once docker file done run 'docker build .' here . is location of docker file
# 2. docker image ls : list images
# 3. docker image rm <imageId> : deletes image
# 4. docker build -t <imageName> <dockerfilePath> : gives name to the image and builds
# 5. Run app: docker run -d --name node-app node-app-image
#   -d : detach cmd line (you can still user your command line it will not be freezed)
#   -name : give name to your docker container 
#    Note: - you will need to rebuild image to reflect code chnages
#          - Or you can use volumes which will allow to sync folder (bi-directional) from host machine to docker file system (no need to rebuild)
#          - '-v pathOfFolderOnLocalMachine: pathOfFolerOnDockerContainer'
#          - docker run -p 3000:3000 -v  pathOfFolderOnLocalMachine: pathOfFolerOnDockerContainer -d --name node-app node-app-image
#          - docker run -p 4000:3000 -v ${pwd}:/app -d  --name node-app node-app-image
#          - changes will not be reflected until you restart server so be sure to use nodemon
# 6. Now your app will be running but it will not be accessible because:
#   - docker conatiner will not be able to connect to external network including host machine port
#   - docker container can access outside world but outsode world cannot access docker (security mechanism)
# 7. docker rm node-app -f : kill the runnign container, deletes the entire container
# 8. docker run -p 3000:3000 -d --name node-app node-app-image
#   -port on left is host machine port that will be used to route traffic to docker 3000 port 
# 9. docker ps : show runnng containers
# 10. docker exec -it node-app bash : to see files , -it: interactive mode 
# 11. docker logs <containerName> : to check logs of node app
# 12. docker ps -a : shows all continaers including crashed ones
# 13. If your are using bind volume and if you delete node_modulesfolder on host it will reflect on docker image as well
#     To solve this issue continue...
#     use: docker run -p 4000:3000 -v ${pwd}:/app -v /app/node_modules -d --name node-app node-app-image (anonymous volume)
# 14. to make only read only bind mount ad :ro
#     docker run -p 4000:3000 -v ${pwd}:/app:ro -v /app/node_modules -d --name node-app node-app-image
# 15. docker rm <containerName> -fv : fv deletes volumes as well as conainers
# 16. docker stop <contianerName> : to stop running container


# How can we make use of enviornment variables?
# Ans: 1. specify them in dockerfile as ENV PORT 3000 or 
#      2. you can specify while runtime
#      3. you can add it as as .env file ans then run docker run command with : --env-file=./. (filepath)
# Note: To check enviorment varaibles:
#       step1:docker exec -it node-app bash 
#       step2:printenv   



# User docker compose to automate





