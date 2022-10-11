FROM nvidia/cuda:11.3.1-base-ubuntu20.04

RUN apt update \
  && apt install python3 python3-pip -y \
  && apt install --no-install-recommends -y curl wget git \
  && apt-get clean

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh \
 && bash ~/miniconda.sh -b -p $HOME/miniconda \
 && $HOME/miniconda/bin/conda init

COPY . /root/esrgan

RUN eval "$($HOME/miniconda/bin/conda shell.bash hook)" \
  && cd /root/esrgan \
  && conda env create -f environment.yaml \
  && conda activate esrgan

RUN ln -s /usr/bin/python3 /usr/bin/python

# VOLUME /output
VOLUME /results
VOLUME /inputs

ENV PYTHONUNBUFFERED=1

RUN ln -s /inputs /root/esrgan/inputs/media
RUN ln -s /results /root/esrgan/results
RUN cd /root/esrgan \
  && python setup.py develop

WORKDIR /root/esrgan

ENTRYPOINT ["/root/esrgan/docker-bootstrap.sh"]
