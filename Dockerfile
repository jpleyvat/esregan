FROM nvidia/cuda:11.3.1-base-ubuntu20.04

RUN apt update \
  && apt install python3 python3-pip -y \
  && apt install --no-install-recommends -y curl wget git \
  && apt-get clean

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh \
 && bash ~/miniconda.sh -b -p $HOME/miniconda \
 && $HOME/miniconda/bin/conda init

COPY . /app

RUN eval "$($HOME/miniconda/bin/conda shell.bash hook)" \
  && cd /app \
  && conda env create -f environment.yaml \
  && conda activate esrgan
  # && pip install numpy install basicsr install facexlib install gfpgan install opencv-python-headless Pillow tqdmk

#RUN pip3 install torch torchvision \
# RUN apt install libsm6 libxext6 libxrender-dev -y

RUN ln -s /usr/bin/python3 /usr/bin/python

# RUN pip3 install -r /app/requirements.txt
# RUN pip install numpy install basicsr install facexlib install gfpgan install opencv-python-headless Pillow tqdm
# CMD pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

# VOLUME /output
VOLUME /app/results
VOLUME /app/inputs

ENV PYTHONUNBUFFERED=1

# RUN rm -rf /app/results && ln -s /output /app/results \
RUN cd /app \
  && python setup.py develop

WORKDIR /app

ENTRYPOINT ["/app/docker-bootstrap.sh"]
