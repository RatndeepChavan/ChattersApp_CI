<h1 align="center">ChattersApp CI<br></h1>
<h3 align="center">Continues Integration for
    <a href="https://github.com/RatndeepChavan/ChattersApp">ChatterApp project</a>
</h3>

<p align="center">
    <img src="https://img.shields.io/github/stars/RatndeepChavan/ChattersApp_CI" alt="Stars">
    <img src="https://img.shields.io/github/forks/RatndeepChavan/ChattersApp_CI" alt="Forks">
    <img src="https://img.shields.io/github/issues/RatndeepChavan/ChattersApp_CI" alt="Issues"><br>
    <a href="http://commitizen.github.io/cz-cli/">
        <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen" alt="Commitizen">
    </a>
    <a href="https://pycqa.github.io/isort/">
        <img src="https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336" alt="isort">
    </a>
    <a href="https://pre-commit.com/">
      <img src="https://img.shields.io/badge/pre--commit-comit--hooks-FAB040?logo=precommit&logoColor=fff&style=flat&labelColor=FAB040&color=grey" alt="pre-commit">
    </a>

</p>

<div align="center">
    <a href="#about">About</a> •
    <a href="#pipeline-steps">Pipeline Steps</a> •
    <a href="#code-analysis">Repo Structure</a> •
    <a href="#how-to-use">How To Use</a> •
    <a href="#references">References</a>
</div>

# About
This is a continues integration pipeline repository for [ChatterApp project](https://github.com/RatndeepChavan/ChattersApp) and automated using **`jenkins`**. To insure the security it **scans packages and file structure for vulnerabilities** present in project code using tools like **`snyk, OWASP and trivy`** before building an docker images. To create a docker images **jenkins pipeline uses host docker** as DinD (docker in docker) is resource hungry concept. Then trivy is used to perform **image scan** and finally **images are push to 'docker hub' repository** for deployment. This project uses following technologies:
- ![Python Badge](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=fff&style=for-the-badge)
- ![GNU Bash Badge](https://img.shields.io/badge/GNU%20Bash-4EAA25?logo=gnubash&logoColor=fff&style=for-the-badge)
- ![Jenkins Badge](https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=fff&style=for-the-badge)
- ![Snyk Badge](https://img.shields.io/badge/Snyk-4C4A73?logo=snyk&logoColor=fff&style=for-the-badge)
- ![OWASP Dependency-Check Badge](https://img.shields.io/badge/OWASP%20Dependency--Check-F78D0A?logo=dependencycheck&logoColor=fff&style=for-the-badge)
- ![Trivy Badge](https://img.shields.io/badge/Trivy-1904DA?logo=trivy&logoColor=fff&style=for-the-badge)
- ![Git Badge](https://img.shields.io/badge/Git-F05032?logo=git&logoColor=fff&style=for-the-badge)
- ![GitHub Badge](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=fff&style=for-the-badge)
- ![Docker Badge](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff&style=for-the-badge)
- ![Alpine Linux Badge](https://img.shields.io/badge/Alpine%20Linux-0D597F?logo=alpinelinux&logoColor=fff&style=for-the-badge)
<br/>
<br/>

# Pipeline Steps:
- **Git clone :** Fetch the latest code from github repository.
- **OWASP dependanct-check :** OWASP dependency scan for vulnerabilities.
- **Snyk :** Snyk security scan on project code.
- **Trivy :** Trivy filesystem scan.
- **Image build :** Docker images build using docker-compose with host docker.io
- **Image scan :** Trivy image scan for security
- **Push images :** Login and push images to docker hub repository

# Repo Structure :
For code readability and maintainability with discipline coding this github repository follows following branching structure and rules.
- **dev/developer** : This is developer specific brach where developer can commit anytime freely. Commit hook checks lining and best practices for code push on this brach.
- **development** : In this branch all developers code get merge. This branch tracks development process and allows developer for send and share. Commit hook performs test cases and checks code coverage before pushing code.
- **production** : This is live production brach and direct commit to this branch is restricted. Developer must generate PR from development branch (which get reviewed by seniors) to commit on this brach.
- **master** : This brach is work as back-up brach for emergency and easy rollback. This brach is also is restricted must generate PR to commit on this brach

**`NOTE :`** This repository is set up using pre-commit hooks to follow conventional commit. Please use `git cz commit` to get conventional commit options.

# How to use:
There are two ways to implement this CI pipeline:
- Use docker container with jenkins alpine image
- Directly install jenkins on server

**`NOTE :`** In both implementation it is considered as starting with new linux server. Also files with prefix as docker are for dockerize implementation.

## Jenkins alpine image as docker container
- First create docker-compose.yml, docker-instance-config.sh and docker-jenkins-config.sh files on server.
- First run docker-instance-config.sh file as :
    ```bash
    sh docker-instance-config.sh
    ```
    This will install docker and docker-compose on instance and allocate require permissions to user to execute docker commands. Creates one data folder for jenkins volume mount and copy the docker-jenkins-config.sh file into it for jenkins installation inside docker container.
- Then build and start jenkins container using :
    ```bash
    docker-compose up --build -d
    # -d : detach mode
    ```
    NOTE: direct docker run command can be also use but using compose for it's readability, maintainability and future scalability.
- Execute docker container's shell as root user:
    ```bash
    docker exec -it --user=root jenkins sh
    # -it : interactive mode
    ```
    **Don't forget to update UID and GID in file**
- Now install set up jenkins container with require tools:
    ```bash
    cd /var/jenkins_home/
    sh docker-jenkins-config.sh

    # alternative in one go
    # sh /var/jenkins_home/docker-jenkins-config.sh
    ```
    Now visit jenkins page using server dns at port 8080 then paste password from specified file and start jenkins.
- For plugin, install suggested plugins OR select manually below once:
    - Credentials Binding
    - Pipeline
    - Git
- Now set up snyk credential key as secret text and create docker password file at root.
- Create new pipeline and copy paste pipeline syntax from docker-jenkinsfile OR set poll SCM option.
- Build the pipeline and check you docker hub repo for new images.

## Direct jenkins installation on server
- Create jenkins-installation.sh file and execute it. This will install jenkins, docker and docker-compose on instance and allocate require permissions to user to execute docker commands. Also it'll set up all the require tools to execute jenkins pipeline.
- Now visit jenkins using server dns at port 8080 and paste password from specified file.
- For plugin, install suggested plugins OR select manually below once:
    - Credentials Binding
    - Pipeline
    - Git
- Now set up snyk credential key as secret text and create docker password file at root.
- Create new pipeline and copy paste pipeline syntax from jenkinsfile OR set poll SCM option.
- Build the pipeline and check you docker hub repo for new images.

**`NOTE:`** Above both setup tested on free tier instance so they uses host docker in jenkins to avoid resource limitations.


# References
- For project please refer [ChattersAPP](https://github.com/RatndeepChavan/ChattersApp) repository.
- For deployment please refer [ChattersAPP_CD](https://github.com/RatndeepChavan/ChattersApp_CD) repository.
