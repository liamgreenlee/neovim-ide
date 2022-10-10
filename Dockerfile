FROM ubuntu:latest
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install --assume-yes \
    git wget python3 pip curl apt-utils \
 && rm -rf /var/lib/apt/lists/*
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install nodejs
RUN ln -sf python3 /usr/bin/python
RUN wget https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb && apt install ./nvim-linux64.deb -y && rm nvim-linux64.deb
RUN groupadd -r nvim-group && useradd -m nvim-user -g nvim-group
RUN npm i -g pyright tree-sitter-cli

USER nvim-user
WORKDIR /home/nvim-user
RUN mkdir -p .config/nvim
RUN /opt/conda/bin/conda init bash

#COPY --chown=nvim-user:nvim-group init.vim /home/nvim-user/.config/nvim/init.vim
COPY --chown=nvim-user:nvim-group ./ /home/nvim-user/.config/nvim/
# RUN nvim --headless +PackerSync +qa
RUN nvim --headless -c 'autocmd User PackerComplete quitall'
# Test bind mount

ENTRYPOINT ["/opt/conda/bin/conda", "run", "--no-capture-output", "-n", "mounted", "nvim"]
