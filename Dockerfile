FROM centos:7

LABEL com.github.actions.name="kiro-clang_tidy"
LABEL com.github.actions.description="Here because everything else sucked."
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="gray-dark"

LABEL repository="https://github.com/kiro47/kiro-clang_tidy"
LABEL maintainer="Kiro47 <kiro47@protonmail.com>"

RUN yum update -y
# Because for dumb reasons I literally cannot find a package with clang tidy
RUN yum install -y centos-release-scl make
RUN yum install -y llvm-toolset-7-clang-tools-extra  llvm-toolset-7-git-clang-format

ENV CC gcc
ENV GXX g++
ENV CODE_DIR /code

RUN mkdir /{code,scripts}

COPY ./gh-action.bash /scripts/


COPY [^gh-action.bash]* /code/

CMD ["/bin/bash", "/scripts/gh-action.bash"]
